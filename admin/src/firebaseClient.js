import { initializeApp, getApps } from 'firebase/app'
import { getAuth } from 'firebase/auth'
import { getFirestore } from 'firebase/firestore'

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY ?? 'AIzaSyCmHG38l2Pn4P9mits_fIb4jauAAPxZzws',
  authDomain:
    import.meta.env.VITE_FIREBASE_AUTH_DOMAIN ?? 'shopsfirebase-a92b0.firebaseapp.com',
  databaseURL:
    import.meta.env.VITE_FIREBASE_DATABASE_URL ??
    'https://shopsfirebase-a92b0-default-rtdb.firebaseio.com',
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID ?? 'shopsfirebase-a92b0',
  storageBucket:
    import.meta.env.VITE_FIREBASE_STORAGE_BUCKET ?? 'shopsfirebase-a92b0.firebasestorage.app',
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID ?? '755342721880',
  appId: import.meta.env.VITE_FIREBASE_APP_ID ?? '1:755342721880:web:32266c0d082b5ff7eddb2d',
}

export const missingFirebaseKeys = Object.entries(firebaseConfig)
  .filter(([, value]) => !String(value).trim())
  .map(([key]) => key)

export const firebaseEnabled = missingFirebaseKeys.length === 0

const app = firebaseEnabled
  ? getApps()[0] ?? initializeApp(firebaseConfig)
  : null

export const auth = app ? getAuth(app) : null
export const db = app ? getFirestore(app) : null
