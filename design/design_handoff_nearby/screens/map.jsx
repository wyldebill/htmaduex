// Map screen — full-bleed styled map + top search + bottom business sheet.

function MapScreen({ onOpenDetail, onSwitchToList }) {
  const p = usePalette();
  const [selected, setSelected] = React.useState(1);
  const [activeCat, setActiveCat] = React.useState('all');
  const [saved, setSaved] = React.useState(new Set([2, 5]));

  const list = React.useMemo(() => (
    activeCat === 'all' ? BUSINESSES : BUSINESSES.filter((b) => b.cat === activeCat)
  ), [activeCat]);

  const sel = BUSINESSES.find((b) => b.id === selected);

  const toggleSave = (id) => {
    setSaved((s) => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });
  };

  return (
    <div style={{ height: '100%', background: p.bg, position: 'relative', fontFamily: TYPE.family, overflow: 'hidden' }}>
      {/* Map layer */}
      <div style={{ position: 'absolute', inset: 0 }}>
        <StyledMap biz={list} selectedId={selected} onSelect={setSelected} p={p}/>
      </div>

      {/* Top: search bar */}
      <div style={{ position: 'absolute', top: 56, left: 0, right: 0, padding: '8px 16px', zIndex: 5 }}>
        <div style={{
          background: p.surface, borderRadius: 16, padding: '12px 14px',
          display: 'flex', alignItems: 'center', gap: 10,
          boxShadow: '0 4px 14px rgba(0,0,0,0.08), 0 1px 3px rgba(0,0,0,0.04)',
        }}>
          <Icon name="search" size={18}/>
          <input placeholder="Search nearby places" readOnly
            style={{ flex: 1, border: 'none', outline: 'none', background: 'transparent', fontSize: 15, fontFamily: TYPE.family, color: p.ink }}/>
          <div style={{ width: 28, height: 28, borderRadius: '50%', background: p.primary, color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 700, fontSize: 12 }}>AM</div>
        </div>

        {/* Category chips */}
        <div style={{ display: 'flex', gap: 8, marginTop: 10, overflowX: 'auto', scrollbarWidth: 'none' }}>
          <Chip p={p} active={activeCat === 'all'} onClick={() => setActiveCat('all')} label="All" sparkle/>
          {CATEGORIES.map((c) => (
            <Chip key={c.id} p={p} active={activeCat === c.id} onClick={() => setActiveCat(c.id)} label={c.label} emoji={c.icon} tint={p[c.tintKey]}/>
          ))}
        </div>
      </div>

      {/* Floating map controls */}
      <div style={{ position: 'absolute', right: 14, top: 190, display: 'flex', flexDirection: 'column', gap: 10, zIndex: 4 }}>
        <MapBtn p={p} icon="layers"/>
        <MapBtn p={p} icon="locate" accent/>
      </div>

      {/* List toggle */}
      <button onClick={onSwitchToList} style={{
        position: 'absolute', bottom: 230, left: '50%', transform: 'translateX(-50%)',
        padding: '10px 18px', background: p.ink, color: '#fff',
        border: 'none', borderRadius: 24, fontSize: 14, fontWeight: 600, fontFamily: TYPE.family,
        display: 'flex', alignItems: 'center', gap: 8, cursor: 'pointer', zIndex: 4,
        boxShadow: '0 6px 18px rgba(0,0,0,0.22)',
      }}>
        <Icon name="list" size={16}/> List view
      </button>

      {/* Bottom sheet with selected business */}
      {sel && (
        <div style={{
          position: 'absolute', left: 0, right: 0, bottom: 0, zIndex: 6,
          background: p.surface, borderTopLeftRadius: 24, borderTopRightRadius: 24,
          padding: '10px 18px 28px',
          boxShadow: '0 -8px 24px rgba(0,0,0,0.08)',
        }}>
          <div style={{ width: 40, height: 4, background: p.border, borderRadius: 2, margin: '0 auto 14px' }}/>
          <div style={{ display: 'flex', gap: 12 }}>
            {(() => {
              const catObj = CATEGORIES.find((c) => c.id === sel.cat);
              const tint = (catObj && p[catObj.tintKey]) || p.primary;
              return (
                <div style={{ width: 64, height: 64, borderRadius: 14, background: softTint(tint, 0.16), border: `1px solid ${softTint(tint, 0.22)}`, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 22 }}>
                  {catObj?.icon}
                </div>
              );
            })()}
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 2 }}>
                <span style={{ fontSize: 11, fontWeight: 700, color: sel.open ? '#0E8F5E' : p.inkFaint, letterSpacing: 0.4 }}>
                  {sel.open ? 'OPEN' : 'CLOSED'}
                </span>
                <span style={{ fontSize: 11, color: p.inkFaint }}>· until {sel.closeTime}</span>
              </div>
              <div style={{ fontSize: 17, fontWeight: 700, color: p.ink, letterSpacing: -0.3, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{sel.name}</div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 13, color: p.inkSoft, marginTop: 2 }}>
                <span style={{ display: 'flex', alignItems: 'center', gap: 3, color: p.ink, fontWeight: 600 }}>
                  <span style={{ color: p.accent, display: 'flex' }}><Icon name="star" size={13}/></span> {sel.rating}
                </span>
                <span>· {sel.reviews} reviews</span>
                <span>· {sel.price}</span>
                <span>· {sel.dist}</span>
              </div>
            </div>
            <button onClick={() => toggleSave(sel.id)} style={{ background: 'none', border: 'none', padding: 6, cursor: 'pointer', color: saved.has(sel.id) ? p.primary : p.inkSoft }}>
              <Icon name={saved.has(sel.id) ? 'heartFill' : 'heart'} size={22}/>
            </button>
          </div>

          <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
            <ActionBtn p={p} icon="dir" label="Directions" filled/>
            <ActionBtn p={p} icon="call" label="Call"/>
            <ActionBtn p={p} icon="share" label="Share"/>
          </div>

          <button onClick={() => onOpenDetail(sel.id)} style={{
            width: '100%', marginTop: 12, padding: '13px', background: 'transparent',
            border: `1.5px solid ${p.border}`, borderRadius: 12,
            fontSize: 14, fontWeight: 600, color: p.ink, fontFamily: TYPE.family,
            cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
          }}>
            View details <Icon name="chev" size={14}/>
          </button>
        </div>
      )}
    </div>
  );
}

function Chip({ p, active, onClick, label, emoji, sparkle, tint }) {
  const bg = active ? (tint || p.ink) : p.surface;
  return (
    <button onClick={onClick} style={{
      padding: '8px 14px', borderRadius: 20, flexShrink: 0,
      background: bg,
      color: active ? '#fff' : p.ink,
      border: `1.5px solid ${active ? bg : 'rgba(0,0,0,0.06)'}`,
      fontSize: 13, fontWeight: 600, fontFamily: TYPE.family, cursor: 'pointer',
      display: 'flex', alignItems: 'center', gap: 5, whiteSpace: 'nowrap',
      boxShadow: active ? 'none' : '0 2px 6px rgba(0,0,0,0.04)',
    }}>
      {sparkle && <Icon name="sparkle" size={13}/>}
      {emoji && <span style={{ fontSize: 13 }}>{emoji}</span>}
      {label}
    </button>
  );
}

function MapBtn({ p, icon, accent }) {
  return (
    <button style={{
      width: 44, height: 44, borderRadius: 14,
      background: accent ? p.primary : p.surface,
      color: accent ? '#fff' : p.ink,
      border: 'none', cursor: 'pointer',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
    }}>
      <Icon name={icon} size={20}/>
    </button>
  );
}

function ActionBtn({ p, icon, label, filled }) {
  return (
    <button style={{
      flex: 1, padding: '10px 8px', borderRadius: 12,
      background: filled ? p.primary : p.chipBg,
      color: filled ? '#fff' : p.ink,
      border: 'none', cursor: 'pointer',
      display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3,
      fontSize: 11, fontWeight: 600, fontFamily: TYPE.family,
    }}>
      <Icon name={icon} size={18}/> {label}
    </button>
  );
}

window.MapScreen = MapScreen;
