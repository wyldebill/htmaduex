import { useEffect, useMemo, useState } from 'react'
import {
  signInWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
} from 'firebase/auth'
import { collection, doc, getDocs, orderBy, query, setDoc } from 'firebase/firestore'

import { auth, db, firebaseEnabled, missingFirebaseKeys } from './firebaseClient'

const PERMISSION_DENIED_MESSAGE =
  'Signed in, but Firestore denied access. Deploy firestore.rules so authenticated users can read/write "businesses".'
const DEFAULT_THUMBNAIL = 'https://cdn.pixabay.com/photo/2013/07/12/13/57/shop-147483_1280.png'

function cloneBusiness(business) {
  return JSON.parse(JSON.stringify(business))
}

function readValue(value) {
  return value ?? ''
}

function setNestedValue(target, path, value) {
  const keys = path.split('.')
  const draft = { ...target }
  let cursor = draft
  for (let i = 0; i < keys.length - 1; i += 1) {
    const key = keys[i]
    cursor[key] = { ...(cursor[key] ?? {}) }
    cursor = cursor[key]
  }
  cursor[keys[keys.length - 1]] = value
  return draft
}

function normalizeBusinessForSave(business) {
  return {
    ...business,
    id: Number(business.id),
    address: {
      ...business.address,
    },
    location: {
      ...business.location,
      lat: Number(business.location?.lat),
      lng: Number(business.location?.lng),
    },
    updatedAt: new Date().toISOString(),
  }
}

function sortBusinessesByName(rows) {
  return [...rows].sort((a, b) => String(a.name ?? '').localeCompare(String(b.name ?? '')))
}

function LoginCard({ onLogin, loginError }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const handleSubmit = (event) => {
    event.preventDefault()
    onLogin(email, password)
  }

  return (
    <main className="auth-shell">
      <section className="card auth-card">
        <h1>Nearby Admin</h1>
        <p className="subtle">Sign in with the same Firebase email/password used in the app.</p>
        <form className="stack" onSubmit={handleSubmit}>
          <label>
            Email
            <input
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              type="email"
              required
              autoComplete="email"
            />
          </label>
          <label>
            Password
            <input
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              type="password"
              required
              autoComplete="current-password"
            />
          </label>
          {loginError ? <p className="error">{loginError}</p> : null}
          <button type="submit">Sign in</button>
        </form>
      </section>
    </main>
  )
}

function App() {
  const [authReady, setAuthReady] = useState(!auth)
  const [user, setUser] = useState(null)
  const [loginError, setLoginError] = useState('')
  const [loadError, setLoadError] = useState('')
  const [notice, setNotice] = useState('')
  const [businesses, setBusinesses] = useState([])
  const [selectedId, setSelectedId] = useState('')
  const [draft, setDraft] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')

  useEffect(() => {
    if (!auth) return undefined
    const unsubscribe = onAuthStateChanged(auth, (nextUser) => {
      setUser(nextUser)
      setAuthReady(true)
      setLoginError('')
      if (!nextUser) {
        setBusinesses([])
        setSelectedId('')
        setDraft(null)
      }
    })
    return unsubscribe
  }, [])

  useEffect(() => {
    if (!db || !user) return

    const loadBusinesses = async () => {
      setLoadError('')
      try {
        const businessesQuery = query(collection(db, 'businesses'), orderBy('id'))
        const snapshot = await getDocs(businessesQuery)
        const rows = snapshot.docs.map((entry) => ({
          docId: entry.id,
          ...entry.data(),
        }))
        const sortedRows = sortBusinessesByName(rows)
        setBusinesses(sortedRows)
        if (sortedRows.length > 0) {
          setSelectedId(sortedRows[0].docId)
          setDraft(cloneBusiness(sortedRows[0]))
        }
      } catch (error) {
        if (error?.code === 'permission-denied') {
          setLoadError(PERMISSION_DENIED_MESSAGE)
          return
        }
        setLoadError(error.message ?? 'Failed to load businesses.')
      }
    }

    loadBusinesses()
  }, [user])

  const selectedBusiness = useMemo(
    () => businesses.find((item) => item.docId === selectedId),
    [businesses, selectedId],
  )
  const filteredBusinesses = useMemo(() => {
    const queryValue = searchTerm.trim().toLowerCase()
    if (!queryValue) return businesses
    return businesses.filter((item) => String(item.name ?? '').toLowerCase().includes(queryValue))
  }, [businesses, searchTerm])

  const handleLogin = async (email, password) => {
    if (!auth) return
    setLoginError('')
    try {
      const credential = await signInWithEmailAndPassword(auth, email.trim(), password)
      if (!credential.user.emailVerified) {
        await signOut(auth)
        setLoginError('Please verify your email before using the admin site.')
      }
    } catch (error) {
      setLoginError(error.message ?? 'Sign in failed.')
    }
  }

  const handleSignOut = async () => {
    if (!auth) return
    await signOut(auth)
    setNotice('')
  }

  const handleSelectBusiness = (docId) => {
    setSelectedId(docId)
    const next = businesses.find((item) => item.docId === docId)
    if (next) {
      setDraft(cloneBusiness(next))
      setNotice('')
    }
  }

  const handleChange = (path, value) => {
    if (!draft) return
    setDraft((current) => setNestedValue(current, path, value))
  }

  const handleSave = async (event) => {
    event.preventDefault()
    if (!db || !draft) return
    try {
      const payload = normalizeBusinessForSave(draft)
      await setDoc(doc(db, 'businesses', draft.docId), payload, { merge: true })
      setBusinesses((current) => {
        const updatedRows = current.map((item) => (item.docId === payload.docId ? payload : item))
        return sortBusinessesByName(updatedRows)
      })
      setDraft((current) =>
        current && current.docId === payload.docId ? cloneBusiness(payload) : current,
      )
      setNotice(`Saved updates for ${payload.name}.`)
    } catch (error) {
      if (error?.code === 'permission-denied') {
        setNotice(PERMISSION_DENIED_MESSAGE)
        return
      }
      setNotice(error.message ?? 'Save failed.')
    }
  }

  if (!firebaseEnabled) {
    return (
      <main className="auth-shell">
        <section className="card auth-card">
          <h1>Nearby Admin</h1>
          <p className="error">
            Missing Firebase web configuration:
            {' '}
            {missingFirebaseKeys.join(', ')}
          </p>
          <p className="subtle">Set these in admin/.env.local, then restart Vite.</p>
        </section>
      </main>
    )
  }

  if (!authReady) {
    return (
      <main className="auth-shell">
        <section className="card auth-card">
          <p className="subtle">Loading…</p>
        </section>
      </main>
    )
  }

  if (!user) {
    return <LoginCard onLogin={handleLogin} loginError={loginError} />
  }

  return (
    <div className="page">
      <header className="topbar">
        <div>
          <p className="eyebrow">Nearby Admin</p>
          <h1>Businesses</h1>
        </div>
        <div className="topbar-actions">
          <span className="subtle">{user.email}</span>
          <button type="button" className="secondary" onClick={handleSignOut}>
            Sign out
          </button>
        </div>
      </header>

      <div className="workspace">
        <aside className="card list-card">
          <h2>All businesses</h2>
          <input
            type="search"
            placeholder="Search by business name"
            value={searchTerm}
            onChange={(event) => setSearchTerm(event.target.value)}
          />
          <div className="business-list">
            {filteredBusinesses.map((business) => (
              <button
                type="button"
                key={business.docId}
                className={business.docId === selectedId ? 'business-item active' : 'business-item'}
                onClick={() => handleSelectBusiness(business.docId)}
              >
                <img
                  src={business.storefrontImage || DEFAULT_THUMBNAIL}
                  alt={business.name}
                  className="thumb"
                />
                <span>{business.name}</span>
              </button>
            ))}
            {filteredBusinesses.length === 0 ? (
              <p className="subtle">No businesses match "{searchTerm}".</p>
            ) : null}
          </div>
        </aside>

        <section className="card form-card">
          {loadError ? <p className="error">{loadError}</p> : null}
          {!selectedBusiness || !draft ? (
            <p className="subtle">No business records found in Firestore collection "businesses".</p>
          ) : (
            <form className="stack" onSubmit={handleSave}>
              <div className="detail-shell">
                <img
                  src={draft.storefrontImage || DEFAULT_THUMBNAIL}
                  alt={draft.name}
                  className="detail-image"
                />
                <div>
                  <p className="eyebrow">Business details</p>
                  <h2>{draft.name}</h2>
                </div>
              </div>
              <div className="grid">
                <label>
                  Name
                  <input
                    value={readValue(draft.name)}
                    onChange={(event) => handleChange('name', event.target.value)}
                    required
                  />
                </label>
                <label>
                  Category
                  <input
                    value={readValue(draft.category)}
                    onChange={(event) => handleChange('category', event.target.value)}
                  />
                </label>
                <label>
                  Owner
                  <input
                    value={readValue(draft.owner)}
                    onChange={(event) => handleChange('owner', event.target.value)}
                  />
                </label>
                <label>
                  Phone
                  <input
                    value={readValue(draft.phone)}
                    onChange={(event) => handleChange('phone', event.target.value)}
                  />
                </label>
                <label>
                  Website
                  <input
                    value={readValue(draft.website)}
                    onChange={(event) => handleChange('website', event.target.value)}
                  />
                </label>
                <label>
                  Hours
                  <input
                    value={readValue(draft.hours)}
                    onChange={(event) => handleChange('hours', event.target.value)}
                  />
                </label>
                <label>
                  Address line
                  <input
                    value={readValue(draft.address?.line1)}
                    onChange={(event) => handleChange('address.line1', event.target.value)}
                  />
                </label>
                <label>
                  City
                  <input
                    value={readValue(draft.address?.city)}
                    onChange={(event) => handleChange('address.city', event.target.value)}
                  />
                </label>
                <label>
                  State
                  <input
                    value={readValue(draft.address?.state)}
                    onChange={(event) => handleChange('address.state', event.target.value)}
                  />
                </label>
                <label>
                  Postal code
                  <input
                    value={readValue(draft.address?.postalCode)}
                    onChange={(event) => handleChange('address.postalCode', event.target.value)}
                  />
                </label>
                <label>
                  Latitude
                  <input
                    value={readValue(draft.location?.lat)}
                    onChange={(event) => handleChange('location.lat', event.target.value)}
                  />
                </label>
                <label>
                  Longitude
                  <input
                    value={readValue(draft.location?.lng)}
                    onChange={(event) => handleChange('location.lng', event.target.value)}
                  />
                </label>
                <label className="span-2">
                  Storefront image URL
                  <input
                    value={readValue(draft.storefrontImage)}
                    onChange={(event) => handleChange('storefrontImage', event.target.value)}
                  />
                </label>
              </div>
              {notice ? <p className="subtle">{notice}</p> : null}
              <button type="submit">Save updates</button>
            </form>
          )}
        </section>
      </div>
    </div>
  )
}

export default App
