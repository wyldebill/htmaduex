// Detail screen — hero image, key info, tabs-like sections, sticky CTA.

function DetailScreen({ bizId, onBack }) {
  const p = usePalette();
  const b = BUSINESSES.find((x) => x.id === bizId) || BUSINESSES[0];
  const [saved, setSaved] = React.useState(false);
  const cat = CATEGORIES.find((c) => c.id === b.cat);

  return (
    <div style={{ height: '100%', background: p.bg, display: 'flex', flexDirection: 'column', fontFamily: TYPE.family, overflow: 'hidden', position: 'relative' }}>
      {/* Scroll area */}
      <div style={{ flex: 1, overflowY: 'auto' }}>
        {/* Hero */}
        <div style={{ position: 'relative', height: 260, background: `linear-gradient(160deg, hsl(${b.hue} 75% 72%), hsl(${b.hue} 65% 52%))`, overflow: 'hidden' }}>
          {/* fake photo — abstract striped placeholder */}
          <svg viewBox="0 0 400 260" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
            <defs>
              <pattern id={`hp-${b.id}`} patternUnits="userSpaceOnUse" width="20" height="20" patternTransform="rotate(15)">
                <rect width="20" height="20" fill={`hsl(${b.hue} 65% 55%)`}/>
                <rect width="10" height="20" fill={`hsl(${b.hue} 70% 62%)`}/>
              </pattern>
            </defs>
            <rect width="400" height="260" fill={`url(#hp-${b.id})`} opacity="0.8"/>
            <circle cx="320" cy="80" r="60" fill={`hsl(${b.hue} 80% 80%)`} opacity="0.7"/>
            <circle cx="80" cy="220" r="100" fill={`hsl(${b.hue} 60% 45%)`} opacity="0.4"/>
            <text x="200" y="140" textAnchor="middle" fontFamily={TYPE.mono} fontSize="11" fill="rgba(255,255,255,0.7)" letterSpacing="2">[ STOREFRONT PHOTO ]</text>
          </svg>

          {/* Top chrome */}
          <div style={{ position: 'absolute', top: 52, left: 0, right: 0, display: 'flex', justifyContent: 'space-between', padding: '8px 14px', zIndex: 2 }}>
            <RoundBtn onClick={onBack} icon="back"/>
            <div style={{ display: 'flex', gap: 8 }}>
              <RoundBtn icon="share"/>
              <RoundBtn icon={saved ? 'bookmarkFill' : 'bookmark'} onClick={() => setSaved(!saved)} accent={saved} p={p}/>
            </div>
          </div>

          {/* Photo count */}
          <div style={{ position: 'absolute', bottom: 16, right: 16, background: 'rgba(0,0,0,0.45)', color: '#fff', padding: '5px 10px', borderRadius: 12, fontSize: 12, fontWeight: 600, backdropFilter: 'blur(8px)' }}>
            1 / 24
          </div>
        </div>

        {/* Header card (pulled up) */}
        <div style={{ padding: '18px 20px 0', marginTop: -28, position: 'relative', background: p.bg, borderTopLeftRadius: 24, borderTopRightRadius: 24 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
            <span style={{ fontSize: 12, padding: '4px 10px', background: softTint(p[cat?.tintKey] || p.primary, 0.16), color: p[cat?.tintKey] || p.primary, borderRadius: 8, fontWeight: 700, display: 'inline-flex', alignItems: 'center', gap: 4 }}>
              <span>{cat?.icon}</span> {cat?.label}
            </span>
            <span style={{ fontSize: 12, padding: '4px 10px', background: b.open ? '#E6F7EE' : p.chipBg, color: b.open ? '#0E8F5E' : p.inkSoft, borderRadius: 8, fontWeight: 700 }}>
              {b.open ? '● Open' : '○ Closed'}
            </span>
          </div>
          <h1 style={{ fontSize: 28, fontWeight: 700, color: p.ink, letterSpacing: -0.6, margin: 0, lineHeight: 1.15 }}>{b.name}</h1>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 14, color: p.inkSoft, marginTop: 8 }}>
            <span style={{ color: p.accent, display: 'flex' }}><Icon name="star" size={14}/></span>
            <span style={{ color: p.ink, fontWeight: 700 }}>{b.rating}</span>
            <span>({b.reviews} reviews)</span>
            <span>·</span>
            <span>{b.price}</span>
            <span>·</span>
            <span>{b.dist}</span>
          </div>
          <p style={{ fontSize: 15, color: p.ink, opacity: 0.85, lineHeight: 1.5, marginTop: 14, marginBottom: 0, textWrap: 'pretty' }}>
            {b.blurb}
          </p>
        </div>

        {/* Quick actions */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: 8, padding: '20px 20px 0' }}>
          <QuickAction p={p} icon="dir" label="Directions"/>
          <QuickAction p={p} icon="call" label="Call"/>
          <QuickAction p={p} icon="web" label="Website"/>
          <QuickAction p={p} icon="share" label="Share"/>
        </div>

        {/* Info rows */}
        <div style={{ margin: '24px 20px 0', background: p.surface, borderRadius: 16, border: `1px solid ${p.border}` }}>
          <InfoRow p={p} icon="pin" title={b.street} sub="Oakland, CA 94607"/>
          <InfoRow p={p} icon="clock" title={b.open ? `Open until ${b.closeTime}` : `Closed · Opens 7:00 AM`} sub="Mon–Fri 7a–8p · Sat 8a–6p"/>
          <InfoRow p={p} icon="web" title="driftwood.coffee" sub="Website" last/>
        </div>

        {/* Photos */}
        <Section p={p} title="Photos" action="See all">
          <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr 1fr', gridTemplateRows: '90px 90px', gap: 6 }}>
            {[0, 1, 2, 3, 4].map((i) => (
              <div key={i} style={{
                background: `linear-gradient(${120 + i * 30}deg, hsl(${(b.hue + i * 30) % 360} 60% 70%), hsl(${(b.hue + i * 30) % 360} 55% 55%))`,
                borderRadius: 10,
                gridColumn: i === 0 ? '1 / 2' : undefined,
                gridRow: i === 0 ? '1 / 3' : undefined,
                position: 'relative', overflow: 'hidden',
              }}>
                {i === 4 && (
                  <div style={{ position: 'absolute', inset: 0, background: 'rgba(0,0,0,0.4)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff', fontWeight: 700, fontSize: 14 }}>+19</div>
                )}
              </div>
            ))}
          </div>
        </Section>

        {/* Reviews */}
        <Section p={p} title="Recent reviews" action="All reviews">
          <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 16 }}>
            <div style={{ fontSize: 38, fontWeight: 700, color: p.ink, letterSpacing: -1 }}>{b.rating}</div>
            <div>
              <div style={{ display: 'flex', gap: 2, color: p.accent, marginBottom: 2 }}>
                {[0, 1, 2, 3, 4].map((i) => <Icon key={i} name="star" size={14}/>)}
              </div>
              <div style={{ fontSize: 12, color: p.inkSoft }}>Based on {b.reviews} reviews</div>
            </div>
          </div>
          {[
            { name: 'Maya L.', text: 'Genuinely the best pour-over in the neighborhood. The sourdough toast with honey is unreal.', rating: 5, when: '2d ago' },
            { name: 'Theo R.', text: 'Nice vibe, friendly staff, quick wifi. My go-to remote-work spot lately.', rating: 4, when: '1w ago' },
          ].map((r, i) => (
            <div key={i} style={{ paddingBottom: 12, marginBottom: 12, borderBottom: i === 0 ? `1px solid ${p.border}` : 'none' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                <div style={{ width: 28, height: 28, borderRadius: '50%', background: softTint(p.accent, 0.18), display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 12, fontWeight: 700, color: p.accent }}>{r.name[0]}</div>
                <span style={{ fontSize: 14, fontWeight: 600, color: p.ink }}>{r.name}</span>
                <span style={{ fontSize: 12, color: p.inkFaint }}>· {r.when}</span>
                <div style={{ marginLeft: 'auto', display: 'flex', gap: 1, color: p.accent }}>
                  {Array.from({ length: r.rating }).map((_, i) => <Icon key={i} name="star" size={11}/>)}
                </div>
              </div>
              <p style={{ fontSize: 13.5, color: p.ink, opacity: 0.8, lineHeight: 1.5, margin: '0 0 0 36px' }}>{r.text}</p>
            </div>
          ))}
        </Section>

        {/* Map preview */}
        <Section p={p} title="Location">
          <div style={{ height: 140, borderRadius: 14, overflow: 'hidden', position: 'relative', border: `1px solid ${p.border}` }}>
            <StyledMap biz={[b]} selectedId={b.id} p={p} showUserDot={false}/>
          </div>
          <div style={{ fontSize: 13, color: p.inkSoft, marginTop: 8 }}>{b.street}, Oakland, CA</div>
        </Section>

        <div style={{ height: 100 }}/>
      </div>

      {/* Sticky CTA */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        padding: '14px 20px 28px',
        background: `linear-gradient(to bottom, transparent, ${p.bg} 30%)`,
        display: 'flex', gap: 10,
      }}>
        <button style={{
          flex: 1, padding: '15px', background: p.primary, color: '#fff',
          border: 'none', borderRadius: 14, fontSize: 15, fontWeight: 700, fontFamily: TYPE.family,
          cursor: 'pointer', boxShadow: `0 10px 24px ${p.primary}35`,
        }}>Book a table</button>
        <button style={{
          width: 54, padding: 0, background: p.ink, color: '#fff',
          border: 'none', borderRadius: 14, cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="dir" size={22}/>
        </button>
      </div>
    </div>
  );
}

function RoundBtn({ icon, onClick, accent, p }) {
  return (
    <button onClick={onClick} style={{
      width: 38, height: 38, borderRadius: '50%',
      background: accent ? (p?.primary || '#F25D3A') : 'rgba(255,255,255,0.92)',
      color: accent ? '#fff' : '#1F1712',
      border: 'none', cursor: 'pointer',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      backdropFilter: 'blur(12px)',
      boxShadow: '0 2px 8px rgba(0,0,0,0.15)',
    }}>
      <Icon name={icon} size={18}/>
    </button>
  );
}

function QuickAction({ p, icon, label }) {
  return (
    <button style={{
      padding: '12px 8px', background: p.surface, border: `1px solid ${p.border}`,
      borderRadius: 12, fontFamily: TYPE.family, fontSize: 12, fontWeight: 600, color: p.ink,
      display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 5, cursor: 'pointer',
    }}>
      <div style={{ color: p.primary }}><Icon name={icon} size={20}/></div>
      {label}
    </button>
  );
}

function InfoRow({ p, icon, title, sub, last }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '14px 16px', borderBottom: last ? 'none' : `1px solid ${p.border}` }}>
      <div style={{ width: 36, height: 36, borderRadius: 10, background: p.chipBg, display: 'flex', alignItems: 'center', justifyContent: 'center', color: p.primary, flexShrink: 0 }}>
        <Icon name={icon} size={18}/>
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: p.ink, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{title}</div>
        <div style={{ fontSize: 12, color: p.inkFaint, marginTop: 1 }}>{sub}</div>
      </div>
      <Icon name="chev" size={14}/>
    </div>
  );
}

function Section({ p, title, action, children }) {
  return (
    <div style={{ padding: '24px 20px 0' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
        <h3 style={{ fontSize: 16, fontWeight: 700, color: p.ink, margin: 0, letterSpacing: -0.2 }}>{title}</h3>
        {action && <a style={{ fontSize: 13, color: p.primary, fontWeight: 600, cursor: 'pointer' }}>{action}</a>}
      </div>
      {children}
    </div>
  );
}

window.DetailScreen = DetailScreen;
