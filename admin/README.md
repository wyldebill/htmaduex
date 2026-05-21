# Admin site deploy — Firebase Hosting

Short intro

This document explains how to build and deploy the admin site to Firebase Hosting. It covers prerequisites, build commands for common setups (static JS or optional Flutter web), firebase init/deploy steps, CI/CD hints, security guidance, preview channels, and troubleshooting.

Prerequisites

- Firebase CLI installed (npm i -g firebase-tools) and authenticated
- Access to the Firebase project and Hosting permissions (Owner/Editor or Hosting Admin)
- Local build tool for the admin site (npm/Yarn for a JS site, or Flutter for a Flutter web admin)
- Native Firebase config (iOS/Android) must NOT be committed; use environment-based secrets or native config files generated at build time

Build steps

Variant A — Static JavaScript app (example)

1. cd admin
2. npm install
3. npm run build

Expect an output directory such as admin/dist or admin/build (adjust firebase.json public accordingly).

Variant B — Optional: Flutter web admin (only if your admin UI is Flutter web)

1. Install Flutter and configure SDK
2. flutter build web --web-renderer html --release --target=web_admin_entry

The Flutter build will emit build/web by default — map this to firebase.json public or copy to admin/build.

Firebase init & deploy

1. firebase login
2. firebase init hosting
   - Choose Existing Project -> select <FIREBASE_PROJECT_ID>
   - When asked for public directory, set it to the admin build output (e.g., admin/dist or admin/build)
   - Configure as a single-page app? Yes (if SPA) to enable rewrites

Sample firebase.json snippet (hosting target "admin")

{
  "hosting": [
    {
      "target": "admin",
      "public": "admin/dist",
      "ignore": ["firebase.json","**/.*","**/node_modules/**"],
      "rewrites": [
        { "source": "**", "destination": "/index.html" }
      ]
    }
  ]
}

Deploy commands

- Deploy only admin hosting target: firebase deploy --only hosting:admin
- Or deploy all configured targets: firebase deploy

CI/CD (GitHub Actions example)

Use GitHub Secrets (do NOT hardcode tokens). Two common approaches:

A. FIREBASE_TOKEN (recommended for quick setups)
- Create a CI token via `firebase login:ci` and add to GitHub Secrets as FIREBASE_TOKEN.

B. Service account (recommended for production)
- Create a GCP service account with the appropriate roles, store credentials JSON in GitHub Secrets, and authenticate during workflow using gcloud or the firebase-tools `--token` method after decoding the secret.

Minimal GitHub Actions job (using FIREBASE_TOKEN):

name: Deploy Admin
on: [push]
jobs:
  deploy-admin:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      - name: Install deps
        run: |
          cd admin
          npm ci
      - name: Build
        run: |
          cd admin
          npm run build
      - name: Deploy
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
        run: |
          npx firebase-tools deploy --only hosting:admin --token "$FIREBASE_TOKEN"

Security notes

- DO NOT commit API keys or private credentials. Use environment variables or native config files generated at build time.
- Use ./tool/sync_secrets.sh or ./tool/sync_secrets.ps1 (if present) to inject native secrets into platform-specific config during local build; do not commit those generated files.
- Store CI secrets in GitHub Secrets or your CI provider's secret store.

Preview channels (optional)

You can deploy previews for testing: firebase hosting:channel:deploy <channel-id> --project <FIREBASE_PROJECT_ID>
Use channels for temporary test URLs and expire them when done.

Troubleshooting

- "No project found": run `firebase use --add` or ensure correct project id (<FIREBASE_PROJECT_ID>) is selected.
- 404s on SPA routes: make sure you have a rewrite to /index.html in firebase.json.
- Wrong public directory: confirm the build outputs to the path configured in firebase.json.
- Permission denied: ensure the service account or token has Hosting deploy permissions.

Quick command example (ordered)

cd admin
# build (variant A)
npm ci && npm run build
# deploy
firebase login
firebase use --add  # select <FIREBASE_PROJECT_ID>
firebase deploy --only hosting:admin

Minimal firebase.json (copy into repo root)

{
  "hosting": [
    {
      "target": "admin",
      "public": "admin/dist",
      "rewrites": [ { "source": "**", "destination": "/index.html" } ]
    }
  ]
}

Notes

- Replace placeholders like <FIREBASE_PROJECT_ID> or $FIREBASE_PROJECT with your real project id via environment/CI secrets.
- This README intentionally contains no secret values.
