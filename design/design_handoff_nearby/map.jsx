// StyledMap — a friendly branded map (not a Google Maps copy).
// SVG-rendered, with parks, roads, water, and a grid of streets.
// Biz pins are plotted by %x/%y from BUSINESSES.

function StyledMap({ biz, selectedId, onSelect, p, showUserDot = true }) {
  return (
    <svg viewBox="0 0 100 100" preserveAspectRatio="xMidYMid slice"
      style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', display: 'block' }}>
      <defs>
        <pattern id="paper" width="4" height="4" patternUnits="userSpaceOnUse">
          <rect width="4" height="4" fill={p.mapLand}/>
          <circle cx="1" cy="1" r="0.15" fill="rgba(0,0,0,0.025)"/>
        </pattern>
        <filter id="pinShadow" x="-40%" y="-20%" width="180%" height="180%">
          <feDropShadow dx="0" dy="0.4" stdDeviation="0.3" floodOpacity="0.25"/>
        </filter>
      </defs>
      {/* land */}
      <rect width="100" height="100" fill="url(#paper)"/>
      {/* water: bay on right */}
      <path d="M78 -5 Q 84 25 86 48 Q 90 70 82 105 L110 105 L110 -5 Z" fill={p.mapWater}/>
      <path d="M78 -5 Q 84 25 86 48 Q 90 70 82 105" stroke={p.mapWater} strokeWidth="0.3" fill="none" opacity="0.5"/>
      {/* river curving through */}
      <path d="M-5 80 Q 20 74 40 82 T 78 90" stroke={p.mapWater} strokeWidth="3.2" fill="none" strokeLinecap="round"/>
      {/* parks */}
      <path d="M58 10 Q 74 8 76 22 Q 72 30 60 28 Q 52 24 58 10 Z" fill={p.mapPark}/>
      <path d="M8 28 Q 22 22 26 34 Q 24 44 12 42 Q 4 38 8 28 Z" fill={p.mapPark}/>
      <circle cx="44" cy="48" r="6" fill={p.mapPark}/>
      {/* roads — main arterials */}
      {[
        'M0 35 L100 32',
        'M0 50 Q 50 52 100 48',
        'M0 68 L80 72',
        'M20 0 L24 100',
        'M46 0 L50 100',
        'M66 0 L70 100',
      ].map((d, i) => (
        <g key={i}>
          <path d={d} stroke={p.mapRoadAlt} strokeWidth="2.6" fill="none" strokeLinecap="round"/>
          <path d={d} stroke={p.mapRoad} strokeWidth="1.9" fill="none" strokeLinecap="round"/>
        </g>
      ))}
      {/* minor grid */}
      {Array.from({ length: 14 }).map((_, i) => (
        <line key={'h'+i} x1={0} x2={100} y1={6 + i*7} y2={6 + i*7} stroke={p.mapRoad} strokeWidth="0.35"/>
      ))}
      {Array.from({ length: 10 }).map((_, i) => (
        <line key={'v'+i} y1={0} y2={100} x1={6 + i*10} x2={6 + i*10} stroke={p.mapRoad} strokeWidth="0.35"/>
      ))}
      {/* neighborhood labels */}
      <g fontFamily={TYPE.family} fontSize="2" fontWeight="700" fill={p.inkFaint} letterSpacing="0.3" textAnchor="middle">
        <text x="18" y="18" opacity="0.65">WEST HILL</text>
        <text x="60" y="8" opacity="0.65">NORTHSIDE</text>
        <text x="44" y="90" opacity="0.65">DOWNTOWN</text>
        <text x="85" y="60" opacity="0.5">BAY</text>
      </g>

      {/* pins */}
      {biz.map((b) => {
        const sel = b.id === selectedId;
        return (
          <g key={b.id} transform={`translate(${b.x} ${b.y})`}
            onClick={(e) => { e.stopPropagation(); onSelect && onSelect(b.id); }}
            style={{ cursor: 'pointer' }} filter="url(#pinShadow)">
            {sel && <circle r="7" fill={p.primary} opacity="0.18"/>}
            {sel && <circle r="4.2" fill={p.primary} opacity="0.28"/>}
            <g transform={sel ? 'scale(1.35)' : 'scale(1)'} style={{ transformOrigin: 'center', transition: 'transform .2s' }}>
              <path d="M0 -4 C 2.8 -4 4.6 -2.2 4.6 0 C 4.6 2.8 0 6.2 0 6.2 C 0 6.2 -4.6 2.8 -4.6 0 C -4.6 -2.2 -2.8 -4 0 -4 Z"
                fill={sel ? p.primary : p.surface} stroke={p.primary} strokeWidth="0.8"/>
              <circle r="1.4" cy="0" fill={sel ? '#fff' : p.primary}/>
            </g>
          </g>
        );
      })}

      {/* user location */}
      {showUserDot && (
        <g transform="translate(50 58)">
          <circle r="3.2" fill={p.primary} opacity="0.18"/>
          <circle r="1.6" fill="#2D7EF5" stroke="#fff" strokeWidth="0.6"/>
        </g>
      )}
    </svg>
  );
}

window.StyledMap = StyledMap;
