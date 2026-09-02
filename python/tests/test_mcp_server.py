"""Focused tests for the MCP server's Godot-facing helpers."""

import asyncio
import json

import httpx
import pytest

import mcp_server

PROJECT_GODOT = """\
; Engine configuration file.
config_version=5

[application]

config/name="My Game"
config/version="1.0"
run/main_scene="res://scenes/main.tscn"

[display]

window/size/viewport_width=1152

[rendering]

environment/defaults/default_clear_color=Color(0.1, 0.1, 0.1, 1)
"""


def _lines(text: str) -> list[str]:
    return text.splitlines(keepends=True)


# ---- _format_setting_value / _apply_settings ----


def test_format_setting_value_preserves_types():
    assert mcp_server._format_setting_value(True) == "true"
    assert mcp_server._format_setting_value(False) == "false"
    assert mcp_server._format_setting_value(1152) == "1152"
    assert mcp_server._format_setting_value(1.5) == "1.5"
    assert mcp_server._format_setting_value("My Game") == '"My Game"'
    assert mcp_server._format_setting_value('say "hi"') == '"say \\"hi\\""'


def test_apply_settings_updates_existing_value_in_its_section():
    lines = _lines(PROJECT_GODOT)
    updated = mcp_server._apply_settings(
        lines,
        {"application/config/name": "Renamed", "display/window/size/viewport_width": 1280},
    )
    text = "".join(updated)
    assert 'config/name="Renamed"' in text
    assert "window/size/viewport_width=1280" in text
    # untouched settings and the header comment survive
    assert 'run/main_scene="res://scenes/main.tscn"' in text
    assert "; Engine configuration file." in text
    # values stay in their own sections
    assert text.index("[application]") < text.index('config/name="Renamed"') < text.index("[display]")
    assert text.index("[display]") < text.index("window/size/viewport_width=1280") < text.index("[rendering]")


def test_apply_settings_inserts_missing_key_into_section():
    lines = _lines(PROJECT_GODOT)
    updated = mcp_server._apply_settings(
        lines, {"display/window/size/viewport_height": 720}
    )
    text = "".join(updated)
    assert "window/size/viewport_height=720" in text
    assert text.index("[display]") < text.index("viewport_height") < text.index("[rendering]")


def test_apply_settings_creates_missing_section_at_end():
    lines = _lines(PROJECT_GODOT)
    updated = mcp_server._apply_settings(
        lines, {"audio/driver/enable_input": False}
    )
    text = "".join(updated)
    assert "[audio]" in text
    assert "driver/enable_input=false" in text
    # new section goes after the last existing one
    assert text.index("[rendering]") < text.index("[audio]")


def test_apply_settings_matches_keys_case_insensitively():
    lines = _lines(PROJECT_GODOT)
    updated = mcp_server._apply_settings(lines, {"Application/Config/Name": "Case"})
    text = "".join(updated)
    assert 'config/name="Case"' in text
    assert text.count('config/name=') == 1


def test_apply_settings_rejects_key_without_section():
    with pytest.raises(ValueError):
        mcp_server._apply_settings(_lines(PROJECT_GODOT), {"bare_key": 1})


def test_update_project_settings_flow_rewrites_file(monkeypatch, tmp_path):
    project = tmp_path / "project"
    project.mkdir()
    (project / "project.godot").write_text(PROJECT_GODOT)
    monkeypatch.setattr(mcp_server, "GODOT_PROJECT_PATH", str(project))

    result = asyncio.run(mcp_server.call_tool(
        "update_project_settings",
        {
            "project_path": ".",
            "settings": {
                "application/config/name": "Typed",
                "display/window/size/viewport_width": 1920,
                "audio/driver/enable_audio_input": True,
            },
        },
    ))
    parsed = json.loads(result[0].text)
    assert parsed["success"] is True

    text = (project / "project.godot").read_text()
    assert 'config/name="Typed"' in text
    assert "window/size/viewport_width=1920" in text
    assert "driver/enable_audio_input=true" in text
    assert text.count("window/size/viewport_width=") == 1
    assert '[application]\n' in text and "[audio]" in text


# ---- _get_auth_token ----


def test_auth_token_prefers_environment(monkeypatch, tmp_path):
    monkeypatch.setenv("GODOT_MCP_TOKEN", "env-token")
    config = tmp_path / "godot_mcp_config.json"
    config.write_text(json.dumps({"GDAI_MCP_TOKEN": "file-token"}))
    monkeypatch.setattr(mcp_server, "GODOT_PROJECT_PATH", str(tmp_path))
    monkeypatch.setattr(mcp_server, "_AUTH_TOKEN", "")
    monkeypatch.setattr(mcp_server, "_AUTH_TOKEN_MTIME", None)

    assert mcp_server._get_auth_token() == "env-token"


def test_auth_token_reads_config_file(monkeypatch, tmp_path):
    monkeypatch.delenv("GODOT_MCP_TOKEN", raising=False)
    config = tmp_path / "godot_mcp_config.json"
    config.write_text(json.dumps({"GDAI_MCP_TOKEN": "file-token"}))
    monkeypatch.setattr(mcp_server, "GODOT_PROJECT_PATH", str(tmp_path))
    monkeypatch.setattr(mcp_server, "_AUTH_TOKEN", "")
    monkeypatch.setattr(mcp_server, "_AUTH_TOKEN_MTIME", None)

    assert mcp_server._get_auth_token() == "file-token"


def test_auth_token_refreshes_when_config_appears_later(monkeypatch, tmp_path):
    """The plugin writes godot_mcp_config.json on first editor load, which may
    be after the MCP server started. The token must not stay permanently
    empty once the file shows up."""
    monkeypatch.delenv("GODOT_MCP_TOKEN", raising=False)
    config = tmp_path / "godot_mcp_config.json"
    monkeypatch.setattr(mcp_server, "GODOT_PROJECT_PATH", str(tmp_path))
    monkeypatch.setattr(mcp_server, "_AUTH_TOKEN", "")
    monkeypatch.setattr(mcp_server, "_AUTH_TOKEN_MTIME", None)

    assert mcp_server._get_auth_token() == ""
    config.write_text(json.dumps({"GDAI_MCP_TOKEN": "late-token"}))
    assert mcp_server._get_auth_token() == "late-token"

    config.write_text(json.dumps({"GDAI_MCP_TOKEN": "rotated-token"}))
    assert mcp_server._get_auth_token() == "rotated-token"


# ---- call_godot_api error mapping ----


class _FakeClient:
    def __init__(self, exc):
        self.exc = exc

    async def post(self, *args, **kwargs):
        raise self.exc


def test_call_godot_api_connect_error_is_actionable(monkeypatch):
    monkeypatch.setenv("GODOT_MCP_TOKEN", "token")

    async def fake_client_factory():
        return _FakeClient(httpx.ConnectError("connection refused"))

    monkeypatch.setattr(mcp_server, "_get_http_client", fake_client_factory)
    result = asyncio.run(mcp_server.call_godot_api("/api/project/info"))
    assert result["success"] is False
    assert "Cannot reach the Godot editor" in result["error"]
    assert mcp_server.GODOT_BASE_URL in result["error"]


def test_call_godot_api_other_http_errors_keep_detail(monkeypatch):
    monkeypatch.setenv("GODOT_MCP_TOKEN", "token")

    async def fake_client_factory():
        return _FakeClient(httpx.TimeoutException("timed out"))

    monkeypatch.setattr(mcp_server, "_get_http_client", fake_client_factory)
    result = asyncio.run(mcp_server.call_godot_api("/api/project/info"))
    assert result["success"] is False
    assert "timed out" in result["error"]


def test_call_godot_api_requires_token(monkeypatch):
    monkeypatch.delenv("GODOT_MCP_TOKEN", raising=False)
    monkeypatch.setattr(mcp_server, "GODOT_PROJECT_PATH", "/nonexistent")
    monkeypatch.setattr(mcp_server, "_AUTH_TOKEN", "")
    monkeypatch.setattr(mcp_server, "_AUTH_TOKEN_MTIME", None)

    result = asyncio.run(mcp_server.call_godot_api("/api/project/info"))
    assert result["success"] is False
    assert "No auth token" in result["error"]


# ---- call_tool launch_godot guards ----


def test_launch_godot_requires_executable(monkeypatch):
    monkeypatch.delenv("GODOT_EXECUTABLE", raising=False)
    result = asyncio.run(mcp_server.call_tool("launch_godot", {}))
    parsed = json.loads(result[0].text)
    assert parsed["success"] is False
    assert "GODOT_EXECUTABLE" in parsed["error"]


def test_launch_godot_requires_project_path(monkeypatch):
    monkeypatch.setenv("GODOT_EXECUTABLE", "/usr/bin/godot")
    monkeypatch.setenv("GODOT_PROJECT_PATH", "")
    result = asyncio.run(mcp_server.call_tool("launch_godot", {"editor_mode": True}))
    parsed = json.loads(result[0].text)
    assert parsed["success"] is False
    assert "project_path" in parsed["error"]
