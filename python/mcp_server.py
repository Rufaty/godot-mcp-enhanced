#!/usr/bin/env python3
"""
Godot MCP Enhanced Server
A comprehensive MCP server for Godot Engine with advanced features for Windsurf AI
"""

import asyncio
import json
import os
from typing import Any, Optional

import httpx
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import (
    Tool,
    TextContent,
    ImageContent,
    EmbeddedResource,
)

# Configuration
GODOT_HOST = os.getenv("GODOT_HOST", "127.0.0.1")
GODOT_PORT = int(os.getenv("GDAI_MCP_SERVER_PORT", "3571"))
GODOT_BASE_URL = f"http://{GODOT_HOST}:{GODOT_PORT}"

# Initialize MCP server
app = Server("godot-mcp-enhanced")


async def call_godot_api(endpoint: str, params: dict = None) -> dict:
    """
    Call Godot HTTP API endpoint with error handling
    """
    url = f"{GODOT_BASE_URL}{endpoint}"
    
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(url, json=params or {})
            response.raise_for_status()
            return response.json()
    except httpx.HTTPError as e:
        return {
            "success": False,
            "error": f"HTTP error calling Godot API: {str(e)}"
        }
    except Exception as e:
        return {
            "success": False,
            "error": f"Error calling Godot API: {str(e)}"
        }


# ===== TOOL DEFINITIONS =====

@app.list_tools()
async def list_tools() -> list[Tool]:
    """List all available MCP tools"""
    return [
        # Project Tools
        Tool(
            name="get_project_info",
            description="Get information about the Godot project including name, version, and settings",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="get_filesystem_tree",
            description="Get a recursive tree view of all files and directories in the project",
            inputSchema={
                "type": "object",
                "properties": {
                    "filters": {
                        "type": "array",
                        "items": {"type": "string"},
                        "description": "File extensions to filter (e.g., ['.gd', '.tscn'])"
                    }
                }
            }
        ),
        Tool(
            name="search_files",
            description="Search for files in the project using fuzzy matching",
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "Search query string"
                    }
                },
                "required": ["query"]
            }
        ),
        Tool(
            name="uid_to_project_path",
            description="Convert a Godot UID (uid://) to a project path (res://)",
            inputSchema={
                "type": "object",
                "properties": {
                    "uid": {
                        "type": "string",
                        "description": "UID string (e.g., 'uid://abc123')"
                    }
                },
                "required": ["uid"]
            }
        ),
        Tool(
            name="project_path_to_uid",
            description="Convert a project path (res://) to a Godot UID",
            inputSchema={
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "Project path (e.g., 'res://scenes/main.tscn')"
                    }
                },
                "required": ["path"]
            }
        ),
        
        # Scene Tools
        Tool(
            name="get_scene_tree",
            description="Get a recursive tree view of all nodes in the current scene with properties",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="get_scene_file_content",
            description="Get the raw content of the current scene file",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="create_scene",
            description="Create a new scene with a specified root node type",
            inputSchema={
                "type": "object",
                "properties": {
                    "scene_path": {
                        "type": "string",
                        "description": "Path where scene will be saved (relative to res://)"
                    },
                    "root_type": {
                        "type": "string",
                        "description": "Type of root node (e.g., 'Node2D', 'Node3D', 'Control')",
                        "default": "Node2D"
                    }
                },
                "required": ["scene_path"]
            }
        ),
        Tool(
            name="open_scene",
            description="Open a scene in the Godot editor",
            inputSchema={
                "type": "object",
                "properties": {
                    "scene_path": {
                        "type": "string",
                        "description": "Path to the scene file"
                    }
                },
                "required": ["scene_path"]
            }
        ),
        Tool(
            name="delete_scene",
            description="Delete a scene file from the project",
            inputSchema={
                "type": "object",
                "properties": {
                    "scene_path": {
                        "type": "string",
                        "description": "Path to the scene file to delete"
                    }
                },
                "required": ["scene_path"]
            }
        ),
        Tool(
            name="add_scene",
            description="Add a scene as a child node to the current scene",
            inputSchema={
                "type": "object",
                "properties": {
                    "scene_path": {
                        "type": "string",
                        "description": "Path to the scene to add"
                    },
                    "parent_node": {
                        "type": "string",
                        "description": "Path to parent node (leave empty for root)"
                    }
                },
                "required": ["scene_path"]
            }
        ),
        Tool(
            name="play_scene",
            description="Play the current scene or a specific scene in Godot",
            inputSchema={
                "type": "object",
                "properties": {
                    "scene_path": {
                        "type": "string",
                        "description": "Optional: specific scene to play (empty for current)"
                    }
                }
            }
        ),
        Tool(
            name="stop_running_scene",
            description="Stop the currently running scene in Godot",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        
        # Node Tools
        Tool(
            name="add_node",
            description="Add a new node to the current scene",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_type": {
                        "type": "string",
                        "description": "Type of node to add (e.g., 'Sprite2D', 'RigidBody2D')"
                    },
                    "node_name": {
                        "type": "string",
                        "description": "Name for the new node"
                    },
                    "parent_node_path": {
                        "type": "string",
                        "description": "Path to parent node (empty for root)"
                    },
                    "properties": {
                        "type": "object",
                        "description": "Properties to set on the node"
                    }
                },
                "required": ["node_type", "node_name"]
            }
        ),
        Tool(
            name="delete_node",
            description="Delete a node from the current scene",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_path": {
                        "type": "string",
                        "description": "Path to the node to delete"
                    }
                },
                "required": ["node_path"]
            }
        ),
        Tool(
            name="duplicate_node",
            description="Duplicate an existing node in the scene",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_path": {
                        "type": "string",
                        "description": "Path to the node to duplicate"
                    }
                },
                "required": ["node_path"]
            }
        ),
        Tool(
            name="move_node",
            description="Move a node to a different parent in the scene",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_path": {
                        "type": "string",
                        "description": "Path to the node to move"
                    },
                    "new_parent_path": {
                        "type": "string",
                        "description": "Path to the new parent node"
                    }
                },
                "required": ["node_path", "new_parent_path"]
            }
        ),
        Tool(
            name="update_property",
            description="Update a property of a node in the scene",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_path": {
                        "type": "string",
                        "description": "Path to the node"
                    },
                    "property": {
                        "type": "string",
                        "description": "Property name to update"
                    },
                    "value": {
                        "description": "New value for the property"
                    }
                },
                "required": ["node_path", "property", "value"]
            }
        ),
        Tool(
            name="add_resource",
            description="Add a resource to a node property (e.g., Shape to CollisionShape)",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_path": {
                        "type": "string",
                        "description": "Path to the node"
                    },
                    "resource_type": {
                        "type": "string",
                        "description": "Type of resource (e.g., 'RectangleShape2D')"
                    },
                    "property": {
                        "type": "string",
                        "description": "Property to assign resource to"
                    },
                    "resource_properties": {
                        "type": "object",
                        "description": "Properties to set on the resource"
                    }
                },
                "required": ["node_path", "resource_type", "property"]
            }
        ),
        Tool(
            name="set_anchor_preset",
            description="Set anchor preset for a Control node",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_path": {
                        "type": "string",
                        "description": "Path to the Control node"
                    },
                    "preset": {
                        "type": "string",
                        "description": "Preset name (e.g., 'center', 'full_rect', 'top_left')"
                    }
                },
                "required": ["node_path", "preset"]
            }
        ),
        Tool(
            name="set_anchor_values",
            description="Set precise anchor values for a Control node",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_path": {
                        "type": "string",
                        "description": "Path to the Control node"
                    },
                    "anchor_left": {"type": "number"},
                    "anchor_top": {"type": "number"},
                    "anchor_right": {"type": "number"},
                    "anchor_bottom": {"type": "number"}
                },
                "required": ["node_path"]
            }
        ),
        
        # Script Tools
        Tool(
            name="get_open_scripts",
            description="Get a list of all scripts open in the editor with their contents",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="view_script",
            description="View and activate a script in the editor",
            inputSchema={
                "type": "object",
                "properties": {
                    "script_path": {
                        "type": "string",
                        "description": "Path to the script file"
                    }
                },
                "required": ["script_path"]
            }
        ),
        Tool(
            name="create_script",
            description="Create a new GDScript file",
            inputSchema={
                "type": "object",
                "properties": {
                    "script_path": {
                        "type": "string",
                        "description": "Path where script will be saved"
                    },
                    "content": {
                        "type": "string",
                        "description": "Script content"
                    },
                    "base_type": {
                        "type": "string",
                        "description": "Base class (e.g., 'Node', 'CharacterBody2D')",
                        "default": "Node"
                    }
                },
                "required": ["script_path"]
            }
        ),
        Tool(
            name="attach_script",
            description="Attach a script to a node in the scene",
            inputSchema={
                "type": "object",
                "properties": {
                    "node_path": {
                        "type": "string",
                        "description": "Path to the node"
                    },
                    "script_path": {
                        "type": "string",
                        "description": "Path to the script file"
                    }
                },
                "required": ["node_path", "script_path"]
            }
        ),
        Tool(
            name="edit_file",
            description="Edit a file using find and replace",
            inputSchema={
                "type": "object",
                "properties": {
                    "file_path": {
                        "type": "string",
                        "description": "Path to the file"
                    },
                    "find": {
                        "type": "string",
                        "description": "Text to find"
                    },
                    "replace": {
                        "type": "string",
                        "description": "Text to replace with"
                    },
                    "regex": {
                        "type": "boolean",
                        "description": "Use regex for find/replace"
                    }
                },
                "required": ["file_path", "find", "replace"]
            }
        ),
        
        # Editor Tools
        Tool(
            name="get_godot_errors",
            description="Get all errors from Godot including script errors, runtime errors, and logs",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="get_editor_screenshot",
            description="Capture a screenshot of the Godot editor window (returns base64-encoded PNG)",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="get_running_scene_screenshot",
            description="Capture a screenshot of the running game window (returns base64-encoded PNG)",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="execute_editor_script",
            description="Execute arbitrary GDScript code in the editor context",
            inputSchema={
                "type": "object",
                "properties": {
                    "code": {
                        "type": "string",
                        "description": "GDScript code to execute"
                    }
                },
                "required": ["code"]
            }
        ),
        Tool(
            name="clear_output_logs",
            description="Clear the output logs in the Godot editor",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        
        # Windsurf-Specific Tools
        Tool(
            name="get_windsurf_context",
            description="Get comprehensive context about the current Godot project state for AI understanding",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="get_live_preview",
            description="Get live preview including screenshot, scene tree, and current script for Windsurf",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        
        # Godot Process Management Tools
        Tool(
            name="check_godot_running",
            description="Check if Godot editor is currently running and responsive",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        Tool(
            name="launch_godot",
            description="Launch Godot editor with the current project. Requires GODOT_EXECUTABLE environment variable to be set.",
            inputSchema={
                "type": "object",
                "properties": {
                    "project_path": {
                        "type": "string",
                        "description": "Path to the Godot project directory (containing project.godot)"
                    },
                    "editor_mode": {
                        "type": "boolean",
                        "description": "Launch in editor mode (true) or run the project (false)",
                        "default": True
                    }
                },
                "required": ["project_path"]
            }
        ),
        Tool(
            name="get_godot_version",
            description="Get the version of Godot that is configured or running",
            inputSchema={
                "type": "object",
                "properties": {},
                "required": []
            }
        ),
        
        # Direct File System Tools (work without Godot running)
        Tool(
            name="read_scene_file",
            description="Read and parse a .tscn scene file directly from the file system",
            inputSchema={
                "type": "object",
                "properties": {
                    "scene_path": {
                        "type": "string",
                        "description": "Path to the scene file (res:// or absolute path)"
                    }
                },
                "required": ["scene_path"]
            }
        ),
        Tool(
            name="write_scene_file",
            description="Write a .tscn scene file directly to the file system",
            inputSchema={
                "type": "object",
                "properties": {
                    "scene_path": {
                        "type": "string",
                        "description": "Path where the scene file will be saved"
                    },
                    "content": {
                        "type": "string",
                        "description": "Complete .tscn file content"
                    }
                },
                "required": ["scene_path", "content"]
            }
        ),
        Tool(
            name="read_script_file",
            description="Read a .gd script file directly from the file system",
            inputSchema={
                "type": "object",
                "properties": {
                    "script_path": {
                        "type": "string",
                        "description": "Path to the script file"
                    }
                },
                "required": ["script_path"]
            }
        ),
        Tool(
            name="write_script_file",
            description="Write a .gd script file directly to the file system",
            inputSchema={
                "type": "object",
                "properties": {
                    "script_path": {
                        "type": "string",
                        "description": "Path where the script file will be saved"
                    },
                    "content": {
                        "type": "string",
                        "description": "Complete script content"
                    }
                },
                "required": ["script_path", "content"]
            }
        ),
        Tool(
            name="read_project_settings",
            description="Read project.godot settings file",
            inputSchema={
                "type": "object",
                "properties": {
                    "project_path": {
                        "type": "string",
                        "description": "Path to the project directory"
                    }
                },
                "required": ["project_path"]
            }
        ),
        Tool(
            name="update_project_settings",
            description="Update specific settings in project.godot file",
            inputSchema={
                "type": "object",
                "properties": {
                    "project_path": {
                        "type": "string",
                        "description": "Path to the project directory"
                    },
                    "settings": {
                        "type": "object",
                        "description": "Settings to update (e.g., {'application/config/name': 'My Game'})"
                    }
                },
                "required": ["project_path", "settings"]
            }
        ),
        Tool(
            name="create_directory",
            description="Create a directory in the project",
            inputSchema={
                "type": "object",
                "properties": {
                    "dir_path": {
                        "type": "string",
                        "description": "Path to the directory to create"
                    }
                },
                "required": ["dir_path"]
            }
        ),
        Tool(
            name="list_directory",
            description="List contents of a directory",
            inputSchema={
                "type": "object",
                "properties": {
                    "dir_path": {
                        "type": "string",
                        "description": "Path to the directory"
                    },
                    "recursive": {
                        "type": "boolean",
                        "description": "List recursively",
                        "default": False
                    }
                },
                "required": ["dir_path"]
            }
        ),
    ]


@app.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent | ImageContent]:
    """Handle tool calls by proxying to Godot HTTP API"""
    
    # Map tool names to API endpoints
    endpoint_map = {
        # Project tools
        "get_project_info": "/api/project/info",
        "get_filesystem_tree": "/api/project/filesystem",
        "search_files": "/api/project/search_files",
        "uid_to_project_path": "/api/project/uid_to_path",
        "project_path_to_uid": "/api/project/path_to_uid",
        
        # Scene tools
        "get_scene_tree": "/api/scene/tree",
        "get_scene_file_content": "/api/scene/file_content",
        "create_scene": "/api/scene/create",
        "open_scene": "/api/scene/open",
        "delete_scene": "/api/scene/delete",
        "add_scene": "/api/scene/add_scene",
        "play_scene": "/api/scene/play",
        "stop_running_scene": "/api/scene/stop",
        
        # Node tools
        "add_node": "/api/node/add",
        "delete_node": "/api/node/delete",
        "duplicate_node": "/api/node/duplicate",
        "move_node": "/api/node/move",
        "update_property": "/api/node/update_property",
        "add_resource": "/api/node/add_resource",
        "set_anchor_preset": "/api/node/set_anchor_preset",
        "set_anchor_values": "/api/node/set_anchor_values",
        
        # Script tools
        "get_open_scripts": "/api/script/get_open_scripts",
        "view_script": "/api/script/view",
        "create_script": "/api/script/create",
        "attach_script": "/api/script/attach",
        "edit_file": "/api/script/edit_file",
        
        # Editor tools
        "get_godot_errors": "/api/editor/errors",
        "get_editor_screenshot": "/api/editor/screenshot",
        "get_running_scene_screenshot": "/api/editor/running_scene_screenshot",
        "execute_editor_script": "/api/editor/execute_script",
        "clear_output_logs": "/api/editor/clear_logs",
        
        # Windsurf tools
        "get_windsurf_context": "/api/windsurf/context",
        "get_live_preview": "/api/windsurf/live_preview",
    }
    
    # Handle Godot process management tools (don't need Godot running)
    if name == "check_godot_running":
        try:
            async with httpx.AsyncClient(timeout=2.0) as client:
                response = await client.get(f"{GODOT_BASE_URL}/project_info")
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "running": True,
                        "responsive": response.status_code == 200
                    }, indent=2)
                )]
        except:
            return [TextContent(
                type="text",
                text=json.dumps({
                    "success": True,
                    "running": False,
                    "responsive": False
                }, indent=2)
            )]
    
    if name == "launch_godot":
        import subprocess
        godot_exe = os.getenv("GODOT_EXECUTABLE")
        if not godot_exe:
            return [TextContent(
                type="text",
                text=json.dumps({
                    "success": False,
                    "error": "GODOT_EXECUTABLE environment variable not set. Please set it to your Godot executable path."
                }, indent=2)
            )]
        
        project_path = arguments.get("project_path")
        editor_mode = arguments.get("editor_mode", True)
        
        try:
            args = [godot_exe]
            if editor_mode:
                args.extend(["--editor", "--path", project_path])
            else:
                args.extend(["--path", project_path])
            
            process = subprocess.Popen(args, 
                                     stdout=subprocess.PIPE, 
                                     stderr=subprocess.PIPE,
                                     creationflags=subprocess.CREATE_NEW_CONSOLE if os.name == 'nt' else 0)
            
            return [TextContent(
                type="text",
                text=json.dumps({
                    "success": True,
                    "message": f"Godot launched successfully with PID {process.pid}",
                    "pid": process.pid,
                    "note": "Wait a few seconds for Godot to start and the MCP server to become available"
                }, indent=2)
            )]
        except Exception as e:
            return [TextContent(
                type="text",
                text=json.dumps({
                    "success": False,
                    "error": f"Failed to launch Godot: {str(e)}"
                }, indent=2)
            )]
    
    if name == "get_godot_version":
        import subprocess
        godot_exe = os.getenv("GODOT_EXECUTABLE")
        if not godot_exe:
            return [TextContent(
                type="text",
                text=json.dumps({
                    "success": False,
                    "error": "GODOT_EXECUTABLE environment variable not set"
                }, indent=2)
            )]
        
        try:
            result = subprocess.run([godot_exe, "--version"], 
                                  capture_output=True, 
                                  text=True, 
                                  timeout=5)
            version = result.stdout.strip()
            return [TextContent(
                type="text",
                text=json.dumps({
                    "success": True,
                    "version": version,
                    "executable": godot_exe
                }, indent=2)
            )]
        except Exception as e:
            return [TextContent(
                type="text",
                text=json.dumps({
                    "success": False,
                    "error": f"Failed to get Godot version: {str(e)}"
                }, indent=2)
            )]
    
    # Handle direct file system tools (work without Godot running)
    if name in ["read_scene_file", "write_scene_file", "read_script_file", "write_script_file",
                "read_project_settings", "update_project_settings", "create_directory", "list_directory"]:
        
        if name == "read_scene_file":
            scene_path = arguments.get("scene_path", "")
            if scene_path.startswith("res://"):
                scene_path = scene_path.replace("res://", "./")
            
            try:
                with open(scene_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "path": scene_path,
                        "content": content
                    }, indent=2)
                )]
            except Exception as e:
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": False,
                        "error": f"Failed to read scene file: {str(e)}"
                    }, indent=2)
                )]
        
        elif name == "write_scene_file":
            scene_path = arguments.get("scene_path", "")
            content = arguments.get("content", "")
            
            if scene_path.startswith("res://"):
                scene_path = scene_path.replace("res://", "./")
            
            try:
                os.makedirs(os.path.dirname(scene_path) if os.path.dirname(scene_path) else ".", exist_ok=True)
                with open(scene_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "path": scene_path,
                        "message": "Scene file written successfully"
                    }, indent=2)
                )]
            except Exception as e:
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": False,
                        "error": f"Failed to write scene file: {str(e)}"
                    }, indent=2)
                )]
        
        elif name == "read_script_file":
            script_path = arguments.get("script_path", "")
            if script_path.startswith("res://"):
                script_path = script_path.replace("res://", "./")
            
            try:
                with open(script_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "path": script_path,
                        "content": content
                    }, indent=2)
                )]
            except Exception as e:
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": False,
                        "error": f"Failed to read script file: {str(e)}"
                    }, indent=2)
                )]
        
        elif name == "write_script_file":
            script_path = arguments.get("script_path", "")
            content = arguments.get("content", "")
            
            if script_path.startswith("res://"):
                script_path = script_path.replace("res://", "./")
            
            try:
                os.makedirs(os.path.dirname(script_path) if os.path.dirname(script_path) else ".", exist_ok=True)
                with open(script_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "path": script_path,
                        "message": "Script file written successfully"
                    }, indent=2)
                )]
            except Exception as e:
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": False,
                        "error": f"Failed to write script file: {str(e)}"
                    }, indent=2)
                )]
        
        elif name == "read_project_settings":
            project_path = arguments.get("project_path", ".")
            settings_file = os.path.join(project_path, "project.godot")
            
            try:
                with open(settings_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "path": settings_file,
                        "content": content
                    }, indent=2)
                )]
            except Exception as e:
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": False,
                        "error": f"Failed to read project settings: {str(e)}"
                    }, indent=2)
                )]
        
        elif name == "update_project_settings":
            project_path = arguments.get("project_path", ".")
            settings = arguments.get("settings", {})
            settings_file = os.path.join(project_path, "project.godot")
            
            try:
                with open(settings_file, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                
                for key, value in settings.items():
                    found = False
                    for i, line in enumerate(lines):
                        if line.startswith(key):
                            lines[i] = f'{key}="{value}"\n'
                            found = True
                            break
                    if not found:
                        lines.append(f'{key}="{value}"\n')
                
                with open(settings_file, 'w', encoding='utf-8') as f:
                    f.writelines(lines)
                
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "message": "Project settings updated successfully"
                    }, indent=2)
                )]
            except Exception as e:
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": False,
                        "error": f"Failed to update project settings: {str(e)}"
                    }, indent=2)
                )]
        
        elif name == "create_directory":
            dir_path = arguments.get("dir_path", "")
            if dir_path.startswith("res://"):
                dir_path = dir_path.replace("res://", "./")
            
            try:
                os.makedirs(dir_path, exist_ok=True)
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "path": dir_path,
                        "message": "Directory created successfully"
                    }, indent=2)
                )]
            except Exception as e:
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": False,
                        "error": f"Failed to create directory: {str(e)}"
                    }, indent=2)
                )]
        
        elif name == "list_directory":
            dir_path = arguments.get("dir_path", ".")
            recursive = arguments.get("recursive", False)
            
            if dir_path.startswith("res://"):
                dir_path = dir_path.replace("res://", "./")
            
            try:
                if recursive:
                    files = []
                    for root, dirs, filenames in os.walk(dir_path):
                        for filename in filenames:
                            files.append(os.path.join(root, filename))
                else:
                    files = [os.path.join(dir_path, f) for f in os.listdir(dir_path)]
                
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": True,
                        "path": dir_path,
                        "files": files,
                        "count": len(files)
                    }, indent=2)
                )]
            except Exception as e:
                return [TextContent(
                    type="text",
                    text=json.dumps({
                        "success": False,
                        "error": f"Failed to list directory: {str(e)}"
                    }, indent=2)
                )]
    
    if name not in endpoint_map:
        return [TextContent(
            type="text",
            text=json.dumps({"success": False, "error": f"Unknown tool: {name}"}, indent=2)
        )]
    
    endpoint = endpoint_map[name]
    result = await call_godot_api(endpoint, arguments or {})
    
    # Handle screenshot results (return as image)
    if name in ["get_editor_screenshot", "get_running_scene_screenshot"]:
        if result.get("success") and "data" in result:
            screenshot_base64 = result["data"].get("screenshot", "")
            if screenshot_base64:
                return [
                    TextContent(type="text", text=f"Screenshot captured successfully"),
                    ImageContent(
                        type="image",
                        data=screenshot_base64,
                        mimeType="image/png"
                    )
                ]
    
    # Handle live preview with image
    if name == "get_live_preview":
        if result.get("success") and "data" in result:
            data = result["data"]
            screenshot = data.get("screenshot", "")
            
            response = [
                TextContent(
                    type="text",
                    text=json.dumps({
                        "scene_tree": data.get("scene_tree"),
                        "current_script": data.get("current_script")
                    }, indent=2)
                )
            ]
            
            if screenshot:
                response.append(ImageContent(
                    type="image",
                    data=screenshot,
                    mimeType="image/png"
                ))
            
            return response
    
    # Default: return JSON result
    return [TextContent(
        type="text",
        text=json.dumps(result, indent=2)
    )]


async def main():
    """Main entry point for the MCP server"""
    async with stdio_server() as (read_stream, write_stream):
        await app.run(
            read_stream,
            write_stream,
            app.create_initialization_options()
        )


if __name__ == "__main__":
    asyncio.run(main())
