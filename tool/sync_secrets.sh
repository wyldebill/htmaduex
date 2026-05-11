#!/usr/bin/env bash
set -euo pipefail

ENV_PATH="${1:-.env}"
if [[ ! -f "$ENV_PATH" ]]; then
  echo "Missing $ENV_PATH. Add required Maps/Firebase keys first." >&2
  exit 1
fi

read_secret() {
  local key="$1"
  local value
  value="$(grep -E "^[[:space:]]*${key}=" "$ENV_PATH" | head -n1 | cut -d'=' -f2- | tr -d '"' | tr -d "'")"
  if [[ -z "${value// }" ]]; then
    echo "${key} is missing or empty in $ENV_PATH." >&2
    exit 1
  fi
  echo "$value"
}

api_key="$(read_secret GOOGLE_MAPS_API_KEY)"
firebase_api_key="$(read_secret FIREBASE_API_KEY)"
firebase_app_id="$(read_secret FIREBASE_APP_ID)"
firebase_sender_id="$(read_secret FIREBASE_MESSAGING_SENDER_ID)"
firebase_project_id="$(read_secret FIREBASE_PROJECT_ID)"
firebase_auth_domain="$(read_secret FIREBASE_AUTH_DOMAIN)"
firebase_storage_bucket="$(read_secret FIREBASE_STORAGE_BUCKET)"
firebase_ios_bundle_id="$(read_secret FIREBASE_IOS_BUNDLE_ID)"

# iOS needs this at build time, so we materialize an ignored xcconfig from .env.
cat > ios/Flutter/Secrets.xcconfig <<EOF
GOOGLE_MAPS_API_KEY=$api_key
FIREBASE_API_KEY=$firebase_api_key
FIREBASE_APP_ID=$firebase_app_id
FIREBASE_MESSAGING_SENDER_ID=$firebase_sender_id
FIREBASE_PROJECT_ID=$firebase_project_id
FIREBASE_AUTH_DOMAIN=$firebase_auth_domain
FIREBASE_STORAGE_BUCKET=$firebase_storage_bucket
FIREBASE_IOS_BUNDLE_ID=$firebase_ios_bundle_id
EOF
echo "Generated ios/Flutter/Secrets.xcconfig"
