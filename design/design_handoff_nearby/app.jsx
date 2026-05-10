// App shell — navigation state machine + bottom tab bar.
// Phone flow: login → wizard → map/list (tabs) → detail

function PhoneApp({ initialScreen = 'login' }) {
  const p = usePalette();
  const [screen, setScreen] = React.useState(initialScreen); // login | wizard | map | list | detail
  const [detailId, setDetailId] = React.useState(1);

  const openDetail = (id) => { setDetailId(id); setScreen('detail'); };
  const fromDetail = () => setScreen('map');

  // Tab bar visible on map + list only
  const showTabs = screen === 'map' || screen === 'list';

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', background: p.bg, overflow: 'hidden' }}>
      {screen === 'login' && <LoginScreen onSignIn={() => setScreen('wizard')}/>}
      {screen === 'wizard' && <WizardScreen onDone={() => setScreen('map')}/>}
      {screen === 'map' && <MapScreen onOpenDetail={openDetail} onSwitchToList={() => setScreen('list')}/>}
      {screen === 'list' && <ListScreen onOpenDetail={openDetail} onSwitchToMap={() => setScreen('map')}/>}
      {screen === 'detail' && <DetailScreen bizId={detailId} onBack={fromDetail}/>}

      {showTabs && <BottomTabs p={p} active={screen} onTab={setScreen}/>}
    </div>
  );
}

function BottomTabs({ p, active, onTab }) {
  const tabs = [
    { id: 'map', label: 'Map', icon: 'map' },
    { id: 'list', label: 'Explore', icon: 'list' },
    { id: 'saved', label: 'Saved', icon: 'saved' },
    { id: 'profile', label: 'Profile', icon: 'profile' },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0, zIndex: 20,
      background: 'rgba(255,255,255,0.94)',
      backdropFilter: 'blur(20px)', WebkitBackdropFilter: 'blur(20px)',
      borderTop: `1px solid ${p.border}`,
      paddingBottom: 22, paddingTop: 8, paddingLeft: 8, paddingRight: 8,
      display: 'flex', justifyContent: 'space-around',
      fontFamily: TYPE.family,
    }}>
      {tabs.map((t) => {
        const is = t.id === active || (active === 'list' && t.id === 'list') || (active === 'map' && t.id === 'map');
        return (
          <button key={t.id} onClick={() => (t.id === 'map' || t.id === 'list') && onTab(t.id)}
            style={{
              flex: 1, padding: '6px 4px', border: 'none', background: 'none',
              display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3, cursor: 'pointer',
              color: is ? p.primary : p.inkFaint,
            }}>
            <Icon name={t.icon} size={22} stroke={is ? 2.2 : 1.8}/>
            <span style={{ fontSize: 10.5, fontWeight: is ? 700 : 500 }}>{t.label}</span>
          </button>
        );
      })}
    </div>
  );
}

window.PhoneApp = PhoneApp;
