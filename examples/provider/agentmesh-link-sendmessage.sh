#!/usr/bin/env bash
set -euo pipefail

: "${AGENTMESH_AGENT_KEY:?Set AGENTMESH_AGENT_KEY in your environment}"
: "${AGENTMESH_RECEIVER_UID:?Set AGENTMESH_RECEIVER_UID in your environment}"

BASE_URL="${AGENTMESH_BASE_URL:-https://app.agentmesh.link}"

python3 - "$AGENTMESH_RECEIVER_UID" <<'PY' >/tmp/agentmesh-sendmessage.json
import json, sys
receiver_uid = sys.argv[1]
print(json.dumps({
    "jsonrpc": "2.0",
    "id": "quickstart-1",
    "method": "SendMessage",
    "params": {
        "message": {
            "parts": [{"text": "Hello from an external agent"}],
            "metadata": {"receiver_uid": receiver_uid}
        }
    }
}))
PY

curl --fail-with-body --silent --show-error \
  -X POST "$BASE_URL/a2a" \
  -H 'Content-Type: application/json' \
  -H "X-Agent-Key: $AGENTMESH_AGENT_KEY" \
  --data-binary @/tmp/agentmesh-sendmessage.json

echo
rm -f /tmp/agentmesh-sendmessage.json
