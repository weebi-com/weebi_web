#!/bin/sh
# Generate config.json from environment variables at container startup.
# Envoy proxy URL must be provided via env vars (API_URL or API_URL_DEV/API_URL_PRD).
# See SECRETS.md for GitHub Actions and Cloud Run setup.

CONFIG_FILE="/usr/share/nginx/html/config.json"

API_URL="${API_URL:-}"
LOCALE="${LOCALE:-fr}"

# If API_URL not set, derive from ENVIRONMENT + API_URL_DEV/API_URL_PRD (set as secrets)
if [ -z "$API_URL" ] && [ -n "$ENVIRONMENT" ]; then
  case "$ENVIRONMENT" in
    production|prd)
      API_URL="${API_URL_PRD:-}"
      ;;
    development|dev)
      API_URL="${API_URL_DEV:-}"
      ;;
    *)
      API_URL="${API_URL_DEV:-}"
      ;;
  esac
fi

echo "{\"API_URL\":\"${API_URL}\",\"LOCALE\":\"${LOCALE}\"}" > "$CONFIG_FILE"
exec nginx -g "daemon off;"
