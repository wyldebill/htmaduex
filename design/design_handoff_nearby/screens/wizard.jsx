// Onboarding wizard — 4 screens, illustrative and friendly.
// Uses abstract SVG illustrations built from the palette (no emoji).

function WizardScreen({ onDone }) {
  const p = usePalette();
  const [step, setStep] = React.useState(0);

  const slides = [
    {
      title: 'Your neighborhood, in one place.',
      body: 'Discover local cafés, shops, and services around you — curated and up to date.',
      art: <ArtMap p={p}/>,
    },
    {
      title: 'Two views, one tap apart.',
      body: 'Browse a map of what\'s nearby, or switch to a list and sort by distance, rating, or price.',
      art: <ArtViews p={p}/>,
    },
    {
      title: 'Find exactly what you need.',
      body: 'Search by name, filter by category, and see open hours at a glance.',
      art: <ArtSearch p={p}/>,
    },
    {
      title: 'Save the spots you love.',
      body: 'Bookmark places, build lists, and share them with friends.',
      art: <ArtSave p={p}/>,
    },
  ];

  const s = slides[step];
  const last = step === slides.length - 1;

  return (
    <div style={{ height: '100%', background: p.bg, display: 'flex', flexDirection: 'column', fontFamily: TYPE.family, position: 'relative' }}>
      {/* Skip */}
      <div style={{ padding: '68px 20px 0', textAlign: 'right' }}>
        {!last && (
          <button onClick={onDone} style={{ border: 'none', background: 'none', color: p.inkSoft, fontSize: 14, fontWeight: 600, cursor: 'pointer' }}>
            Skip
          </button>
        )}
      </div>

      {/* Art */}
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '0 32px', minHeight: 320 }}>
        <div style={{ width: '100%', maxWidth: 300, aspectRatio: '1 / 1' }}>
          {s.art}
        </div>
      </div>

      {/* Copy */}
      <div style={{ padding: '0 32px' }}>
        <h1 style={{ fontSize: 26, fontWeight: 700, color: p.ink, letterSpacing: -0.5, margin: 0, lineHeight: 1.2, textWrap: 'balance' }}>
          {s.title}
        </h1>
        <p style={{ fontSize: 15.5, color: p.inkSoft, lineHeight: 1.5, marginTop: 10, marginBottom: 0, textWrap: 'pretty' }}>
          {s.body}
        </p>
      </div>

      {/* Dots + CTA */}
      <div style={{ padding: '28px 24px 40px' }}>
        <div style={{ display: 'flex', gap: 6, justifyContent: 'center', marginBottom: 22 }}>
          {slides.map((_, i) => (
            <div key={i} style={{
              height: 6, borderRadius: 3,
              width: i === step ? 24 : 6,
              background: i === step ? p.primary : p.border,
              transition: 'all .25s',
            }}/>
          ))}
        </div>
        <button onClick={() => last ? onDone() : setStep(step + 1)} style={{
          width: '100%', padding: '15px 16px',
          background: p.primary, color: '#fff',
          border: 'none', borderRadius: 14, fontSize: 16, fontWeight: 700,
          fontFamily: TYPE.family, cursor: 'pointer',
          boxShadow: `0 10px 24px ${p.primary}35`,
        }}>
          {last ? 'Get started' : 'Continue'}
        </button>
      </div>
    </div>
  );
}

// ── Illustrations ──────────────────────────────────────────

function ArtMap({ p }) {
  return (
    <svg viewBox="0 0 200 200" style={{ width: '100%', height: '100%' }}>
      <defs>
        <linearGradient id="artMapBg" x1="0" x2="1" y1="0" y2="1">
          <stop offset="0" stopColor={p.primarySoft}/>
          <stop offset="1" stopColor={p.bg}/>
        </linearGradient>
      </defs>
      {/* rounded map card */}
      <rect x="20" y="30" width="160" height="140" rx="24" fill="url(#artMapBg)"/>
      {/* roads */}
      <path d="M20 90 Q 90 100 180 80" stroke={p.surface} strokeWidth="4" fill="none"/>
      <path d="M70 30 L85 170" stroke={p.surface} strokeWidth="4" fill="none"/>
      <path d="M140 30 L130 170" stroke={p.surface} strokeWidth="4" fill="none"/>
      {/* park */}
      <circle cx="110" cy="60" r="18" fill={p.mapPark}/>
      {/* pins */}
      <g transform="translate(60 70)">
        <circle r="16" fill={p.primary} opacity="0.15"/>
        <path d="M0 -11 C 6 -11 10 -7 10 -1 C 10 6 0 16 0 16 C 0 16 -10 6 -10 -1 C -10 -7 -6 -11 0 -11 Z" fill={p.primary}/>
        <circle r="3.5" fill="#fff"/>
      </g>
      <g transform="translate(140 120)">
        <path d="M0 -9 C 5 -9 8 -6 8 -1 C 8 5 0 13 0 13 C 0 13 -8 5 -8 -1 C -8 -6 -5 -9 0 -9 Z" fill={p.surface} stroke={p.primary} strokeWidth="1.5"/>
        <circle r="2.5" fill={p.primary}/>
      </g>
      <g transform="translate(95 140)">
        <path d="M0 -9 C 5 -9 8 -6 8 -1 C 8 5 0 13 0 13 C 0 13 -8 5 -8 -1 C -8 -6 -5 -9 0 -9 Z" fill={p.surface} stroke={p.tint1} strokeWidth="1.5"/>
        <circle r="2.5" fill={p.tint1}/>
      </g>
      {/* compass card */}
      <g transform="translate(155 45)">
        <circle r="12" fill="#fff"/>
        <path d="M0 -7 L3 0 L0 7 L-3 0 Z" fill={p.primary}/>
      </g>
    </svg>
  );
}

function ArtViews({ p }) {
  return (
    <svg viewBox="0 0 200 200" style={{ width: '100%', height: '100%' }}>
      {/* map behind */}
      <rect x="10" y="30" width="120" height="150" rx="18" fill={p.primarySoft}/>
      <path d="M10 100 Q 70 95 130 105" stroke="#fff" strokeWidth="3" fill="none"/>
      <circle cx="55" cy="80" r="14" fill={p.mapPark}/>
      <g transform="translate(75 120)">
        <path d="M0 -9 C 5 -9 8 -6 8 -1 C 8 5 0 13 0 13 C 0 13 -8 5 -8 -1 C -8 -6 -5 -9 0 -9 Z" fill={p.primary}/>
        <circle r="2.5" fill="#fff"/>
      </g>
      {/* list card on top */}
      <g transform="translate(70 20)">
        <rect width="120" height="160" rx="18" fill="#fff" stroke={p.border}/>
        {[0, 1, 2, 3].map((i) => (
          <g key={i} transform={`translate(0 ${15 + i * 36})`}>
            <rect x="12" y="4" width="28" height="28" rx="8" fill={p.primarySoft}/>
            <rect x="48" y="8" width="56" height="6" rx="3" fill={p.ink} opacity="0.8"/>
            <rect x="48" y="20" width="40" height="4" rx="2" fill={p.inkFaint}/>
          </g>
        ))}
      </g>
    </svg>
  );
}

function ArtSearch({ p }) {
  return (
    <svg viewBox="0 0 200 200" style={{ width: '100%', height: '100%' }}>
      {/* search bar */}
      <rect x="20" y="30" width="160" height="40" rx="20" fill="#fff" stroke={p.border} strokeWidth="1.5"/>
      <circle cx="40" cy="50" r="7" fill="none" stroke={p.inkSoft} strokeWidth="2"/>
      <path d="M46 56l4 4" stroke={p.inkSoft} strokeWidth="2" strokeLinecap="round"/>
      <rect x="58" y="46" width="70" height="6" rx="3" fill={p.inkFaint} opacity="0.6"/>
      <rect x="58" y="46" width="48" height="6" rx="3" fill={p.primary}/>
      {/* chips */}
      {[{ x: 20, w: 50, label: 'Cafés', active: true }, { x: 76, w: 52, label: 'Shops' }, { x: 134, w: 46, label: 'Food' }].map((c, i) => (
        <g key={i}>
          <rect x={c.x} y="85" width={c.w} height="30" rx="15" fill={c.active ? p.ink : '#fff'} stroke={c.active ? p.ink : p.border} strokeWidth="1.5"/>
          <text x={c.x + c.w / 2} y="104" textAnchor="middle" fontFamily={TYPE.family} fontWeight="600" fontSize="11" fill={c.active ? '#fff' : p.ink}>{c.label}</text>
        </g>
      ))}
      {/* result cards */}
      {[0, 1].map((i) => (
        <g key={i} transform={`translate(20 ${130 + i * 34})`}>
          <rect width="160" height="30" rx="10" fill="#fff" stroke={p.border}/>
          <rect x="8" y="6" width="18" height="18" rx="5" fill={p.primarySoft}/>
          <rect x="34" y="9" width="80" height="5" rx="2.5" fill={p.ink} opacity="0.85"/>
          <rect x="34" y="18" width="60" height="4" rx="2" fill={p.inkFaint}/>
          <circle cx="146" cy="15" r="3" fill={p.tint2}/>
        </g>
      ))}
    </svg>
  );
}

function ArtSave({ p }) {
  return (
    <svg viewBox="0 0 200 200" style={{ width: '100%', height: '100%' }}>
      {/* phone card */}
      <rect x="40" y="20" width="120" height="160" rx="20" fill="#fff" stroke={p.border}/>
      <rect x="52" y="36" width="96" height="60" rx="10" fill={p.primarySoft}/>
      {/* big heart */}
      <g transform="translate(100 66)">
        <path d="M0 14 C -14 4 -18 -8 -10 -12 C -4 -14 0 -10 0 -6 C 0 -10 4 -14 10 -12 C 18 -8 14 4 0 14 Z" fill={p.primary}/>
      </g>
      <rect x="52" y="108" width="72" height="6" rx="3" fill={p.ink} opacity="0.85"/>
      <rect x="52" y="120" width="48" height="5" rx="2.5" fill={p.inkFaint}/>
      <rect x="52" y="140" width="96" height="28" rx="14" fill={p.ink}/>
      <text x="100" y="158" textAnchor="middle" fontFamily={TYPE.family} fontWeight="700" fontSize="11" fill="#fff">Saved</text>
      {/* floating pins */}
      <g transform="translate(36 46)">
        <circle r="12" fill="#fff" stroke={p.border}/>
        <path d="M0 -5 C 3 -5 4 -3 4 0 C 4 3 0 7 0 7 C 0 7 -4 3 -4 0 C -4 -3 -3 -5 0 -5 Z" fill={p.tint1}/>
      </g>
      <g transform="translate(164 128)">
        <circle r="12" fill="#fff" stroke={p.border}/>
        <path d="M0 -5 C 3 -5 4 -3 4 0 C 4 3 0 7 0 7 C 0 7 -4 3 -4 0 C -4 -3 -3 -5 0 -5 Z" fill={p.tint2}/>
      </g>
    </svg>
  );
}

window.WizardScreen = WizardScreen;
