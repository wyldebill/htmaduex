// List screen — searchable, sortable index of businesses.

function ListScreen({ onOpenDetail, onSwitchToMap }) {
  const p = usePalette();
  const [q, setQ] = React.useState('');
  const [sort, setSort] = React.useState('distance');
  const [cat, setCat] = React.useState('all');
  const [sortOpen, setSortOpen] = React.useState(false);
  const [saved, setSaved] = React.useState(new Set([2, 5]));

  const items = React.useMemo(() => {
    let r = BUSINESSES.slice();
    if (cat !== 'all') r = r.filter((b) => b.cat === cat);
    if (q.trim()) {
      const ql = q.toLowerCase();
      r = r.filter((b) => b.name.toLowerCase().includes(ql) || b.tags.some((t) => t.toLowerCase().includes(ql)));
    }
    r.sort((a, b) => {
      if (sort === 'rating') return b.rating - a.rating;
      if (sort === 'name') return a.name.localeCompare(b.name);
      if (sort === 'price') return a.price.length - b.price.length;
      return parseFloat(a.dist) - parseFloat(b.dist);
    });
    return r;
  }, [q, sort, cat]);

  const toggleSave = (id, e) => {
    e.stopPropagation();
    setSaved((s) => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });
  };

  const sortLabels = { distance: 'Distance', rating: 'Rating', name: 'Name (A-Z)', price: 'Price' };

  return (
    <div style={{ height: '100%', background: p.bg, display: 'flex', flexDirection: 'column', fontFamily: TYPE.family, overflow: 'hidden' }}>
      {/* Header */}
      <div style={{ padding: '56px 20px 0', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginTop: 8 }}>
          <h1 style={{ fontSize: 28, fontWeight: 700, color: p.ink, letterSpacing: -0.6, margin: 0 }}>Nearby you</h1>
          <button onClick={onSwitchToMap} style={{ border: 'none', background: 'none', color: p.primary, fontSize: 14, fontWeight: 700, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 4 }}>
            <Icon name="map" size={16}/> Map
          </button>
        </div>
        <p style={{ fontSize: 13, color: p.inkSoft, margin: '2px 0 14px' }}>{items.length} places within 1.5 mi · Oakland, CA</p>

        {/* Search */}
        <div style={{
          background: p.surface, borderRadius: 14, padding: '11px 14px',
          display: 'flex', alignItems: 'center', gap: 10,
          border: `1.5px solid ${p.border}`,
        }}>
          <Icon name="search" size={18}/>
          <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search by name or tag"
            style={{ flex: 1, border: 'none', outline: 'none', background: 'transparent', fontSize: 15, fontFamily: TYPE.family, color: p.ink }}/>
          {q && <button onClick={() => setQ('')} style={{ border: 'none', background: 'none', color: p.inkFaint, padding: 0, cursor: 'pointer' }}><Icon name="close" size={16}/></button>}
        </div>

        {/* Sort & Cat */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, margin: '12px 0 10px', position: 'relative' }}>
          <button onClick={() => setSortOpen(!sortOpen)} style={{
            padding: '7px 12px', borderRadius: 20, border: `1.5px solid ${p.border}`,
            background: p.surface, fontSize: 13, fontWeight: 600, color: p.ink,
            fontFamily: TYPE.family, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 6,
          }}>
            <Icon name="sort" size={14}/> {sortLabels[sort]} <Icon name="chevDown" size={13}/>
          </button>
          {sortOpen && (
            <div style={{
              position: 'absolute', top: '100%', left: 0, marginTop: 4,
              background: p.surface, borderRadius: 12, padding: 6, minWidth: 160,
              boxShadow: '0 8px 24px rgba(0,0,0,0.12)', zIndex: 10,
            }}>
              {Object.entries(sortLabels).map(([k, v]) => (
                <button key={k} onClick={() => { setSort(k); setSortOpen(false); }} style={{
                  display: 'block', width: '100%', textAlign: 'left', padding: '8px 12px',
                  border: 'none', background: sort === k ? p.chipBg : 'transparent',
                  borderRadius: 7, fontSize: 14, color: p.ink, fontWeight: sort === k ? 700 : 500,
                  fontFamily: TYPE.family, cursor: 'pointer',
                }}>{v}</button>
              ))}
            </div>
          )}
          <div style={{ flex: 1 }}/>
          <span style={{ fontSize: 12, color: p.inkFaint, fontWeight: 600 }}>{items.length} results</span>
        </div>

        <div style={{ display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none', marginRight: -20 }}>
          <Chip p={p} active={cat === 'all'} onClick={() => setCat('all')} label="All"/>
          {CATEGORIES.map((c) => (
            <Chip key={c.id} p={p} active={cat === c.id} onClick={() => setCat(c.id)} label={c.label} emoji={c.icon} tint={p[c.tintKey]}/>
          ))}
        </div>
      </div>

      {/* List */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '14px 16px 90px' }}>
        {items.length === 0 && (
          <div style={{ textAlign: 'center', color: p.inkSoft, padding: 40, fontSize: 14 }}>
            No places match "{q}".
          </div>
        )}
        {items.map((b) => {
          const catObj = CATEGORIES.find((c) => c.id === b.cat);
          const tint = (catObj && p[catObj.tintKey]) || p.primary;
          return (
          <div key={b.id} onClick={() => onOpenDetail(b.id)} style={{
            display: 'flex', gap: 14, padding: 14, background: p.surface,
            borderRadius: 16, marginBottom: 10, cursor: 'pointer',
            border: `1px solid ${p.border}`,
          }}>
            <div style={{ width: 72, height: 72, borderRadius: 14, background: softTint(tint, 0.16), flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 26, position: 'relative', border: `1px solid ${softTint(tint, 0.22)}` }}>
              {catObj?.icon}
              {b.open && <div style={{ position: 'absolute', bottom: 6, right: 6, width: 10, height: 10, borderRadius: '50%', background: '#2DBB7A', border: '2px solid #fff' }}/>}
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 2 }}>
                <span style={{ fontSize: 16, fontWeight: 700, color: p.ink, letterSpacing: -0.2 }}>{b.name}</span>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, color: p.inkSoft, marginBottom: 6 }}>
                <span style={{ color: p.accent, display: 'flex', alignItems: 'center' }}><Icon name="star" size={12}/></span>
                <span style={{ color: p.ink, fontWeight: 600 }}>{b.rating}</span>
                <span>({b.reviews})</span>
                <span>·</span>
                <span>{b.price}</span>
                <span>·</span>
                <span>{b.dist}</span>
              </div>
              <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                <span style={{ fontSize: 11, padding: '3px 8px', background: softTint(tint, 0.14), borderRadius: 8, color: tint, fontWeight: 700 }}>{catObj?.label}</span>
                {b.tags.slice(0, 2).map((t) => (
                  <span key={t} style={{ fontSize: 11, padding: '3px 8px', background: p.chipBg, borderRadius: 8, color: p.inkSoft, fontWeight: 600 }}>{t}</span>
                ))}
              </div>
            </div>
            <button onClick={(e) => toggleSave(b.id, e)} style={{ background: 'none', border: 'none', padding: 4, cursor: 'pointer', color: saved.has(b.id) ? p.primary : p.inkFaint, alignSelf: 'flex-start' }}>
              <Icon name={saved.has(b.id) ? 'heartFill' : 'heart'} size={20}/>
            </button>
          </div>
          );
        })}
      </div>
    </div>
  );
}

window.ListScreen = ListScreen;
