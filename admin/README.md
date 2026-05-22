# Nearby Admin

React + Vite admin UI for managing Firestore `businesses` documents.

## What the admin site does

1. Authenticates with Firebase Email/Password (same credentials as the app).
2. Lists all business records from Firestore collection `businesses`.
3. Lets you select a business and edit key fields:
   - name, category, owner
   - phone, website, hours
   - address fields
   - latitude/longitude
   - storefront image URL
4. Saves updates directly to Firestore.
5. Requires verified email login (matches app auth behavior).

## Local setup

1. `cp .env.example .env.local`
2. Fill Firebase web config values in `.env.local`
3. `npm install`
4. `npm run dev`

Use the same Firebase email/password credentials as the app.
The app includes default config for `shopsfirebase-a92b0`; `.env.local` values override defaults.

## Notes

- Collection name is currently hardcoded to `businesses`.
- This is an MVP admin: fast, simple UI with no loading animations.

## Firestore permissions (required)

If you see `Missing or insufficient permissions`, deploy the repository's Firestore
rules so signed-in users can access `businesses`:

1. `firebase login`
2. `firebase use shopsfirebase-a92b0`
3. `firebase deploy --only firestore:rules`
