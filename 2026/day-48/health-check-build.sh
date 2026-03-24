#!/usr/bin/env bash
set -e

URL="${1:-http://localhost:3000/api/health}"

echo "Checking $URL ..."
HTTP_CODE=$(curl -s -o /tmp/health.json -w "%{http_code}" "$URL")

if [ "$HTTP_CODE" != "200" ]; then
  echo "Health check failed: HTTP $HTTP_CODE"
  exit 1
fi

if ! grep -q '"status":"ok"' /tmp/health.json; then
  echo "Health check failed: status not ok"
  cat /tmp/health.json
  exit 1
fi

echo "Health check passed"
cat /tmp/health.json