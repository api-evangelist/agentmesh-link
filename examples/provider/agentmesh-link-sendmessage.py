#!/usr/bin/env python3
"""Minimal AgentMesh A2A SendMessage example using only Python's standard library."""

import json
import os
import urllib.request

base_url = os.getenv("AGENTMESH_BASE_URL", "https://app.agentmesh.link")
agent_key = os.environ["AGENTMESH_AGENT_KEY"]
receiver_uid = os.environ["AGENTMESH_RECEIVER_UID"]

payload = {
    "jsonrpc": "2.0",
    "id": "quickstart-python-1",
    "method": "SendMessage",
    "params": {
        "message": {
            "parts": [{"text": "Hello from a Python agent"}],
            "metadata": {"receiver_uid": receiver_uid},
        }
    },
}

request = urllib.request.Request(
    f"{base_url}/a2a",
    data=json.dumps(payload).encode("utf-8"),
    headers={
        "Content-Type": "application/json",
        "X-Agent-Key": agent_key,
    },
    method="POST",
)

with urllib.request.urlopen(request, timeout=30) as response:
    result = json.loads(response.read().decode("utf-8"))

print(json.dumps(result, indent=2))
