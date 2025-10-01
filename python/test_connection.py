#!/usr/bin/env python3
"""
Test script to verify Godot MCP Enhanced connection
Run this to ensure everything is working correctly
"""

import asyncio
import sys
import httpx
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich import print as rprint

console = Console()

GODOT_HOST = "127.0.0.1"
GODOT_PORT = 3571
BASE_URL = f"http://{GODOT_HOST}:{GODOT_PORT}"


async def test_endpoint(client: httpx.AsyncClient, name: str, endpoint: str, params: dict = None) -> dict:
    """Test a single endpoint"""
    try:
        response = await client.post(f"{BASE_URL}{endpoint}", json=params or {}, timeout=5.0)
        response.raise_for_status()
        data = response.json()
        return {"name": name, "status": "✅ PASS", "response": data.get("success", False)}
    except httpx.ConnectError:
        return {"name": name, "status": "❌ FAIL", "error": "Cannot connect to Godot"}
    except httpx.TimeoutException:
        return {"name": name, "status": "⏱️ TIMEOUT", "error": "Request timed out"}
    except Exception as e:
        return {"name": name, "status": "❌ FAIL", "error": str(e)}


async def run_tests():
    """Run all connection tests"""
    
    console.print("\n[bold cyan]🧪 Godot MCP Enhanced - Connection Test[/bold cyan]\n")
    
    # Test endpoints
    tests = [
        ("Project Info", "/api/project/info", {}),
        ("Filesystem Tree", "/api/project/filesystem", {"filters": [".gd"]}),
        ("Scene Tree", "/api/scene/tree", {}),
        ("Open Scripts", "/api/script/get_open_scripts", {}),
        ("Godot Errors", "/api/editor/errors", {}),
    ]
    
    results = []
    
    console.print("[yellow]Testing connection to Godot...[/yellow]")
    console.print(f"[dim]Target: {BASE_URL}[/dim]\n")
    
    async with httpx.AsyncClient() as client:
        # Test basic connectivity first
        try:
            response = await client.get(f"http://{GODOT_HOST}:{GODOT_PORT}/", timeout=2.0)
            console.print("[green]✓[/green] Server is reachable\n")
        except:
            console.print("[red]✗[/red] Cannot connect to server")
            console.print(f"\n[yellow]Make sure:[/yellow]")
            console.print("1. Godot is running with your project open")
            console.print("2. MCP Enhanced plugin is enabled")
            console.print("3. Server is started in the MCP Enhanced tab")
            console.print(f"4. Port {GODOT_PORT} is not blocked by firewall\n")
            return
        
        # Run tests
        console.print("[yellow]Running endpoint tests...[/yellow]\n")
        
        for name, endpoint, params in tests:
            result = await test_endpoint(client, name, endpoint, params)
            results.append(result)
            
            status_color = "green" if "PASS" in result["status"] else "red"
            console.print(f"  {result['status']} [dim]{name}[/dim]")
    
    # Display results table
    console.print("\n")
    table = Table(title="Test Results", show_header=True, header_style="bold magenta")
    table.add_column("Test", style="cyan")
    table.add_column("Status", justify="center")
    table.add_column("Details", style="dim")
    
    passed = 0
    failed = 0
    
    for result in results:
        table.add_row(
            result["name"],
            result["status"],
            result.get("error", "OK") if "FAIL" in result["status"] else "✓ Success"
        )
        
        if "PASS" in result["status"]:
            passed += 1
        else:
            failed += 1
    
    console.print(table)
    
    # Summary
    console.print("\n")
    if failed == 0:
        panel = Panel(
            "[bold green]✓ All tests passed![/bold green]\n\n"
            "Your Godot MCP Enhanced setup is working correctly.\n"
            "You can now use it with Windsurf AI!",
            title="[bold green]SUCCESS[/bold green]",
            border_style="green"
        )
    else:
        panel = Panel(
            f"[bold yellow]⚠ {failed} test(s) failed[/bold yellow]\n\n"
            f"Passed: {passed}/{len(results)}\n"
            f"Failed: {failed}/{len(results)}\n\n"
            "Check the errors above and ensure:\n"
            "• Godot project is open\n"
            "• Plugin is enabled and server is running\n"
            "• No firewall is blocking connections",
            title="[bold yellow]PARTIAL SUCCESS[/bold yellow]",
            border_style="yellow"
        )
    
    console.print(panel)
    
    # Next steps
    if failed == 0:
        console.print("\n[bold cyan]Next Steps:[/bold cyan]")
        console.print("1. Configure Windsurf with the MCP server")
        console.print("2. Try: [cyan]@godot get_project_info[/cyan]")
        console.print("3. Read the docs: [dim]docs/WINDSURF_SETUP.md[/dim]\n")


async def test_screenshot():
    """Test screenshot functionality specifically"""
    console.print("\n[bold cyan]📸 Testing Screenshot Capture[/bold cyan]\n")
    
    async with httpx.AsyncClient(timeout=10.0) as client:
        try:
            response = await client.post(f"{BASE_URL}/api/editor/screenshot", json={})
            response.raise_for_status()
            data = response.json()
            
            if data.get("success") and data.get("data", {}).get("screenshot"):
                screenshot_data = data["data"]["screenshot"]
                console.print("[green]✓[/green] Screenshot captured successfully!")
                console.print(f"[dim]Size: {len(screenshot_data)} bytes (base64)[/dim]")
            else:
                console.print("[yellow]⚠[/yellow] Screenshot endpoint responded but no data")
                
        except Exception as e:
            console.print(f"[red]✗[/red] Screenshot test failed: {str(e)}")


async def main():
    """Main test runner"""
    try:
        # Check if rich is installed
        try:
            import rich
        except ImportError:
            print("Installing required package 'rich' for better output...")
            import subprocess
            subprocess.check_call([sys.executable, "-m", "pip", "install", "rich"])
            print("Please run the test again.\n")
            return
        
        await run_tests()
        
        # Optionally test screenshot
        console.print("\n[dim]Want to test screenshot capture? (y/n)[/dim] ", end="")
        try:
            # This won't work in async context perfectly, but it's just a test script
            import sys
            import select
            
            # For Windows compatibility, just test it automatically
            if sys.platform == "win32":
                await test_screenshot()
            else:
                # Unix-like systems
                if select.select([sys.stdin], [], [], 2.0)[0]:
                    choice = sys.stdin.readline().strip().lower()
                    if choice == 'y':
                        await test_screenshot()
        except:
            pass
        
    except KeyboardInterrupt:
        console.print("\n\n[yellow]Test cancelled by user[/yellow]")
    except Exception as e:
        console.print(f"\n[red]Error running tests: {str(e)}[/red]")


if __name__ == "__main__":
    # Check Python version
    if sys.version_info < (3, 10):
        print("❌ Python 3.10 or higher is required")
        print(f"   Current version: {sys.version}")
        sys.exit(1)
    
    asyncio.run(main())
