#!/usr/bin/env bash
set -euo pipefail

ENV_PATH="${1:-.env}"
if [[ ! -f "$ENV_PATH" ]]; then
  echo "Missing $ENV_PATH. Add GOOGLE_MAPS_API_KEY first." >&2
  exit 1
fi

api_key="$(grep -E '^[[:space:]]*GOOGLE_MAPS_API_KEY=' "$ENV_PATH" | head -n1 | cut -d'=' -f2- | tr -d '"' | tr -d "'")"
if [[ -z "${api_key// }" ]]; then
  echo "GOOGLE_MAPS_API_KEY is missing or empty in $ENV_PATH." >&2
  exit 1
fi

# iOS needs this at build time, so we materialize an ignored xcconfig from .env.
echo "GOOGLE_MAPS_API_KEY=$api_key" > ios/Flutter/Secrets.xcconfig
echo "Generated ios/Flutter/Secrets.xcconfig"
