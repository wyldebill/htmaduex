import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '..');
const dataPath = path.join(rootDir, 'assets', 'data', 'buffalo_businesses.json');
const collectionName = process.env.FIRESTORE_COLLECTION ?? 'businesses';

initializeApp({
  credential: applicationDefault(),
  projectId: process.env.FIREBASE_PROJECT_ID,
});

const db = getFirestore();

const raw = await fs.readFile(dataPath, 'utf8');
const payload = JSON.parse(raw);
const businesses = payload.businesses ?? [];

if (!Array.isArray(businesses) || businesses.length === 0) {
  throw new Error('No businesses found in assets/data/buffalo_businesses.json');
}

let seeded = 0;
for (const business of businesses) {
  const id = String(business.id);
  await db.collection(collectionName).doc(id).set(
    {
      ...business,
      seededAt: new Date().toISOString(),
    },
    { merge: true },
  );
  seeded += 1;
}

console.log(
  `Seeded ${seeded} businesses to Firestore collection "${collectionName}".`,
);
