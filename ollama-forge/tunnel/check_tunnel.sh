#!/usr/bin/env bash
set -euo pipefail

# ===== AI Forge tunnel config =====
CONFIG_FILE="${CONFIG_FILE:-/root/ollama-forge/config.env}"
if [ -f "$CONFIG_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
  set +a
fi

: "${CF_TUNNEL_UUID:?Set CF_TUNNEL_UUID in $CONFIG_FILE}"
: "${CF_HOSTNAME:?Set CF_HOSTNAME in $CONFIG_FILE}"
CF_TUNNEL_NAME="${CF_TUNNEL_NAME:-${CF_HOSTNAME}}"
CF_LOCAL_PORT="${CF_LOCAL_PORT:-3000}"

LOG_FILE="/root/cloudflared.log"

echo "[INFO] tunnel name : $CF_TUNNEL_NAME"
echo "[INFO] hostname    : $CF_HOSTNAME"
echo "[INFO] local port  : $CF_LOCAL_PORT"

if pgrep -af "cloudflared tunnel run ${CF_TUNNEL_NAME}" >/dev/null; then
  echo "[OK] tunnel process is running"
  pgrep -af "cloudflared tunnel run ${CF_TUNNEL_NAME}"
else
  echo "[ERROR] tunnel process is not running"
  exit 1
fi

if [ -f "$LOG_FILE" ]; then
  echo "[OK] log file exists: $LOG_FILE"
  echo "----------------------------------------"
  tail -n 20 "$LOG_FILE" || true
else
  echo "[WARN] log file not found: $LOG_FILE"
fi
