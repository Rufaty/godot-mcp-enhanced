#!/usr/bin/env python3
"""
Simple test script to verify Godot MCP Enhanced connection
Run this to check if Godot's HTTP server is accessible
"""

import requests
import json
import sys

GODOT_HOST = "127.0.0.1"
GODOT_PORT = 3571
BASE_URL = f"http://{GODOT_HOST}:{GODOT_PORT}"

def test_connection():
    """Test basic connectivity to Godot"""
    print("🧪 Testing Godot MCP Enhanced Connection\n")
    print(f"Target: {BASE_URL}\n")
    
    # Test 1: Server reachability
    print("1️⃣ Testing server reachability...")
    try:
        response = requests.get(f"{BASE_URL}/", timeout=2)
        print("   ✅ Server is reachable!\n")
    except requests.exceptions.ConnectionError:
        print("   ❌ Cannot connect to server")
        print("\n⚠️  Make sure:")
        print("   • Godot is running with your project open")
        print("   • MCP Enhanced plugin is enabled")
        print("   • Server is started in the MCP Enhanced tab")
        print(f"   • Port {GODOT_PORT} is not blocked\n")
        return False
    except Exception as e:
        print(f"   ❌ Error: {e}\n")
        return False
    
    # Test 2: Project info endpoint
    print("2️⃣ Testing project info endpoint...")
    try:
        response = requests.post(f"{BASE_URL}/api/project/info", json={}, timeout=5)
        response.raise_for_status()
        data = response.json()
        
        if data.get("success"):
            print("   ✅ Project info retrieved!")
            if "data" in data:
                project_data = data["data"]
                print(f"   📋 Project Name: {project_data.get('name', 'N/A')}")
                print(f"   📋 Godot Version: {project_data.get('version', 'N/A')}")
        else:
            print(f"   ⚠️  API returned error: {data.get('error', 'Unknown')}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False
    
    print()
    
    # Test 3: Scene tree endpoint
    print("3️⃣ Testing scene tree endpoint...")
    try:
        response = requests.post(f"{BASE_URL}/api/scene/tree", json={}, timeout=5)
        response.raise_for_status()
        data = response.json()
        
        if data.get("success"):
            print("   ✅ Scene tree retrieved!")
            if "data" in data and data["data"]:
                scene_data = data["data"]
                print(f"   🎬 Root Node: {scene_data.get('name', 'N/A')}")
                print(f"   🎬 Type: {scene_data.get('type', 'N/A')}")
        else:
            print(f"   ⚠️  {data.get('error', 'No scene open')}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    
    print()
    
    # Test 4: Open scripts endpoint
    print("4️⃣ Testing open scripts endpoint...")
    try:
        response = requests.post(f"{BASE_URL}/api/script/get_open_scripts", json={}, timeout=5)
        response.raise_for_status()
        data = response.json()
        
        if data.get("success"):
            scripts = data.get("data", [])
            print(f"   ✅ Found {len(scripts)} open script(s)")
            for script in scripts[:3]:  # Show first 3
                print(f"   📝 {script.get('path', 'N/A')}")
        else:
            print(f"   ⚠️  {data.get('error', 'Error getting scripts')}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    
    print()
    print("=" * 50)
    print("✅ Connection test complete!")
    print("\nYour Godot MCP Enhanced setup is working!")
    print("\n📚 Next steps:")
    print("   1. Restart Windsurf to load the MCP server")
    print("   2. Try: @godot get_project_info")
    print("   3. Try: @godot get_scene_tree")
    print("=" * 50)
    return True


if __name__ == "__main__":
    try:
        success = test_connection()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n⚠️  Test cancelled by user")
        sys.exit(1)
