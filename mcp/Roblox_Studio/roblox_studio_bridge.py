import sys
import os
import json
import subprocess
import threading

LOG_FILE = os.path.expanduser(r"~\.gemini\roblox_bridge.log")

def log(msg):
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(f"{msg}\n")
    except Exception:
        pass

# Ensure UTF-8 for stdin and stdout
if hasattr(sys.stdin, "reconfigure"):
    sys.stdin.reconfigure(encoding="utf-8")
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

# Find StudioMCP.exe dynamically (picks the newest version installed)
import glob
candidates = glob.glob(os.path.expandvars(r"%LOCALAPPDATA%\Roblox\Versions\*\StudioMCP.exe"))
if candidates:
    # Sort candidates by file modification time (newest version first)
    candidates.sort(key=lambda x: os.path.getmtime(x), reverse=True)
    target_exe = candidates[0]
else:
    # Fallback to direct path or default version
    target_exe = os.path.expandvars(r"%LOCALAPPDATA%\Roblox\Versions\version-574ecee7ee2b4e60\StudioMCP.exe")

log(f"Starting Roblox MCP Bridge with executable: {target_exe}")

if not os.path.exists(target_exe):
    log(f"Error: StudioMCP.exe not found at '{target_exe}'")
    sys.exit(1)

proc = subprocess.Popen(
    [target_exe],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
    encoding="utf-8",
    bufsize=1
)

def stderr_reader():
    for line in proc.stderr:
        log(f"[STUDIO_STDERR] {line.strip()}")

def stdout_forwarder():
    for line in proc.stdout:
        log(f"[STUDIO -> ANTIGRAVITY] {line.strip()}")
        sys.stdout.write(line)
        sys.stdout.flush()

threading.Thread(target=stderr_reader, daemon=True).start()
threading.Thread(target=stdout_forwarder, daemon=True).start()

try:
    for line in sys.stdin:
        line_str = line.strip()
        if not line_str:
            continue
        
        log(f"[ANTIGRAVITY -> BRIDGE] {line_str}")
        
        try:
            msg = json.loads(line_str)
        except Exception:
            msg = None
            
        if isinstance(msg, dict):
            # Check for server/discover probe
            if msg.get("method") == "server/discover":
                req_id = msg.get("id")
                log(f"[BRIDGE INTERCEPT] server/discover requested with id {req_id}. Replying with Method not found.")
                err_resp = json.dumps({
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "error": {
                        "code": -32601,
                        "message": "Method not found"
                    }
                }) + "\n"
                sys.stdout.write(err_resp)
                sys.stdout.flush()
                continue
        
        # Forward to StudioMCP
        proc.stdin.write(line)
        proc.stdin.flush()
        
except Exception as e:
    log(f"[BRIDGE ERROR] {e}")
finally:
    log("Bridge shutting down...")
    try:
        proc.terminate()
        proc.wait(timeout=2)
    except Exception:
        pass
