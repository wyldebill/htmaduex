import process from 'node:process';

import { applicationDefault, initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const projectId = process.env.FIREBASE_PROJECT_ID;
if (!projectId) {
  throw new Error('Set FIREBASE_PROJECT_ID before running this script.');
}

const collectionName = process.env.FIRESTORE_COLLECTION ?? 'businesses';

initializeApp({
  credential: applicationDefault(),
  projectId,
});

const svg = `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#2563EB"/>
      <stop offset="100%" stop-color="#4F46E5"/>
    </linearGradient>
  </defs>
  <rect width="640" height="640" rx="64" fill="#EEF2FF"/>
  <rect x="88" y="214" width="464" height="292" rx="20" fill="#FFFFFF" stroke="#CBD5E1" stroke-width="10"/>
  <rect x="68" y="168" width="504" height="86" rx="18" fill="url(#bg)"/>
  <rect x="122" y="278" width="162" height="174" rx="12" fill="#E2E8F0"/>
  <rect x="322" y="278" width="198" height="34" rx="8" fill="#DBEAFE"/>
  <rect x="322" y="328" width="168" height="24" rx="8" fill="#E2E8F0"/>
  <rect x="322" y="366" width="184" height="24" rx="8" fill="#E2E8F0"/>
  <text x="320" y="580" text-anchor="middle" font-family="Arial, sans-serif" font-size="36" font-weight="700" fill="#334155">Nearby Business</text>
</svg>`;

const storefrontImage = `data:image/svg+xml;utf8,${encodeURIComponent(svg)}`;

const db = getFirestore();
const snapshot = await db.collection(collectionName).get();
if (snapshot.empty) {
  throw new Error(`No docs found in Firestore collection "${collectionName}".`);
}

const docs = snapshot.docs;
const chunkSize = 400;
let updated = 0;
for (let i = 0; i < docs.length; i += chunkSize) {
  const batch = db.batch();
  for (const doc of docs.slice(i, i + chunkSize)) {
    batch.set(
      db.collection(collectionName).doc(doc.id),
      {
        storefrontImage,
        storefrontImageSource: 'firebase-firestore-inline',
        storefrontImageUpdatedAt: new Date().toISOString(),
      },
      { merge: true },
    );
    updated += 1;
  }
  await batch.commit();
}

console.log(`Updated ${updated} docs in "${collectionName}" with inline fallback image data.`);
console.log(`storefrontImage=${storefrontImage}`);
