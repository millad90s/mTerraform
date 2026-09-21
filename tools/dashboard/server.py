#!/usr/bin/env python3
"""Local Terraform dashboard. Stdlib only, binds to 127.0.0.1.

Run:  python3 tools/dashboard/server.py   ->  http://127.0.0.1:8787
"""
import json, os, re, subprocess, threading, uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
LIVE = ROOT / "live"
HERE = Path(__file__).parent
ACTIONS = {
    "init": ["init", "-input=false", "-no-color"],
    "plan": ["plan", "-input=false", "-no-color"],
    "apply": ["apply", "-auto-approve", "-input=false", "-no-color"],
    "destroy": ["destroy", "-auto-approve", "-input=false", "-no-color"],
}
JOBS = {}          # id -> {env, action, lines, done, code}
RUNNING = {}       # env -> job id
LOCK = threading.Lock()


def envs():
    return sorted(p.name for p in LIVE.iterdir() if p.is_dir() and list(p.glob("*.tf")))


def env_dir(name):
    if name not in envs():
        raise ValueError("unknown environment")
    return LIVE / name


def tf(env, *args):
    r = subprocess.run(["terraform", *args], cwd=env_dir(env), capture_output=True, text=True)
    return r.returncode, r.stdout + r.stderr


def parse_variables(d):
    out = []
    for f in d.glob("*.tf"):
        for m in re.finditer(r'variable\s+"(\w+)"\s*\{(.*?)\n\}', f.read_text(), re.S):
            body = m.group(2)
            g = lambda k: (re.search(rf'{k}\s*=\s*(.+)', body) or [None, None])[1]
            out.append({"name": m.group(1),
                        "type": (g("type") or "string").strip(),
                        "default": (g("default") or "").strip().strip('"'),
                        "description": (g("description") or "").strip().strip('"')})
    return out


def env_info(env):
    d = env_dir(env)
    tfvars = d / "terraform.tfvars.json"
    values = json.loads(tfvars.read_text()) if tfvars.exists() else {}
    code, res = tf(env, "state", "list")
    resources = res.split() if code == 0 else []
    code, o = tf(env, "output", "-json")
    outputs = {}
    if code == 0 and o.strip():
        try: outputs = {k: v["value"] for k, v in json.loads(o).items()}
        except Exception: pass
    return {"name": env, "variables": parse_variables(d), "values": values,
            "resources": resources, "outputs": outputs, "running": RUNNING.get(env)}


def run_job(job, env, action):
    try:
        p = subprocess.Popen(["terraform", *ACTIONS[action]], cwd=env_dir(env),
                             stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        for line in p.stdout:
            job["lines"].append(line.rstrip("\n"))
        job["code"] = p.wait()
    except Exception as e:
        job["lines"].append(f"error: {e}"); job["code"] = 1
    finally:
        job["done"] = True
        with LOCK: RUNNING.pop(env, None)


class H(BaseHTTPRequestHandler):
    def log_message(self, *a): pass

    def send(self, obj, code=200, ctype="application/json"):
        b = obj if isinstance(obj, bytes) else json.dumps(obj).encode()
        self.send_response(code); self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(b))); self.end_headers(); self.wfile.write(b)

    def guard(self):
        # DNS-rebinding / CSRF protection: only accept our own origin
        host = self.headers.get("Host", "")
        origin = self.headers.get("Origin")
        ok_host = host in ("127.0.0.1:8787", "localhost:8787")
        return ok_host and (origin is None or origin.split("//")[-1] == host)

    def do_GET(self):
        if not self.guard(): return self.send({"error": "forbidden"}, 403)
        try:
            if self.path == "/":
                return self.send((HERE / "index.html").read_bytes(), ctype="text/html; charset=utf-8")
            if self.path == "/api/envs":
                return self.send(envs())
            if m := re.fullmatch(r"/api/envs/([\w-]+)", self.path):
                return self.send(env_info(m[1]))
            if m := re.fullmatch(r"/api/jobs/(\w+)\?from=(\d+)", self.path):
                j = JOBS[m[1]]; n = int(m[2])
                return self.send({"lines": j["lines"][n:], "next": len(j["lines"]),
                                  "done": j["done"], "code": j["code"]})
            self.send({"error": "not found"}, 404)
        except Exception as e:
            self.send({"error": str(e)}, 400)

    def do_POST(self):
        if not self.guard(): return self.send({"error": "forbidden"}, 403)
        try:
            body = json.loads(self.rfile.read(int(self.headers.get("Content-Length", 0))) or b"{}")
            if m := re.fullmatch(r"/api/envs/([\w-]+)/vars", self.path):
                d = env_dir(m[1])
                types = {v["name"]: v["type"] for v in parse_variables(d)}
                vals = {k: (float(v) if types.get(k) == "number" and v != "" else v)
                        for k, v in body.items() if k in types and v != ""}
                vals = {k: (int(v) if isinstance(v, float) and v.is_integer() else v) for k, v in vals.items()}
                (d / "terraform.tfvars.json").write_text(json.dumps(vals, indent=2))
                return self.send({"ok": True})
            if m := re.fullmatch(r"/api/envs/([\w-]+)/(init|plan|apply|destroy)", self.path):
                env, action = m[1], m[2]; env_dir(env)
                with LOCK:
                    if env in RUNNING: return self.send({"error": "a job is already running"}, 409)
                    jid = uuid.uuid4().hex[:8]
                    job = JOBS[jid] = {"lines": [f"$ terraform {' '.join(ACTIONS[action])}"], "done": False, "code": None}
                    RUNNING[env] = jid
                threading.Thread(target=run_job, args=(job, env, action), daemon=True).start()
                return self.send({"job": jid})
            self.send({"error": "not found"}, 404)
        except Exception as e:
            self.send({"error": str(e)}, 400)


if __name__ == "__main__":
    print("Dashboard: http://127.0.0.1:8787")
    ThreadingHTTPServer(("127.0.0.1", 8787), H).serve_forever()
