// Login screen — email + password + social sign-in.
// Split-layout: brand panel top, form below. Soft, warm, friendly.

function LoginScreen({ onSignIn, startInSignup = false }) {
  const p = usePalette();
  const [mode, setMode] = React.useState(startInSignup ? 'signup' : 'signin');
  const [email, setEmail] = React.useState('');
  const [pwd, setPwd] = React.useState('');
  const [focus, setFocus] = React.useState(null);

  const field = (label, val, set, name, type = 'text') => (
    <div style={{ marginBottom: 14 }}>
      <label style={{ display: 'block', fontSize: 12, fontWeight: 600, color: p.inkSoft, marginBottom: 6, letterSpacing: 0.2 }}>{label}</label>
      <input type={type} value={val} onChange={(e) => set(e.target.value)}
        onFocus={() => setFocus(name)} onBlur={() => setFocus(null)}
        placeholder={name === 'email' ? 'you@example.com' : '••••••••'}
        style={{
          width: '100%', boxSizing: 'border-box',
          padding: '14px 16px', fontSize: 15, fontFamily: TYPE.family,
          background: p.surface, color: p.ink,
          border: `1.5px solid ${focus === name ? p.primary : p.border}`,
          borderRadius: 12, outline: 'none',
          transition: 'border-color .15s, box-shadow .15s',
          boxShadow: focus === name ? `0 0 0 4px ${p.primarySoft}` : 'none',
        }}/>
    </div>
  );

  const socialBtn = (icon, label) => (
    <button style={{
      flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      padding: '12px 14px', border: `1.5px solid ${p.border}`, background: p.surface,
      borderRadius: 12, fontSize: 14, fontWeight: 600, color: p.ink, fontFamily: TYPE.family,
      cursor: 'pointer',
    }}>
      <Icon name={icon} size={18}/> {label}
    </button>
  );

  return (
    <div style={{ height: '100%', background: p.bg, display: 'flex', flexDirection: 'column', fontFamily: TYPE.family }}>
      {/* Brand header */}
      <div style={{
        padding: '72px 28px 32px',
        background: `linear-gradient(170deg, ${p.primarySoft} 0%, ${p.bg} 100%)`,
        position: 'relative', overflow: 'hidden',
      }}>
        {/* decorative pins */}
        <svg viewBox="0 0 160 110" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', opacity: 0.5 }}>
          <g fill="none" stroke={p.primary} strokeOpacity="0.25" strokeWidth="1">
            <circle cx="130" cy="20" r="18"/><circle cx="130" cy="20" r="10"/>
            <circle cx="24" cy="80" r="14"/><circle cx="24" cy="80" r="7"/>
          </g>
          <g fill={p.primary} opacity="0.35">
            <circle cx="130" cy="20" r="3"/>
            <circle cx="24" cy="80" r="3"/>
          </g>
        </svg>
        <div style={{ position: 'relative' }}>
          {/* logo mark */}
          <div style={{ display: 'inline-flex', alignItems: 'center', gap: 10, marginBottom: 28 }}>
            <div style={{ width: 36, height: 36, borderRadius: 10, background: p.primary, display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff', boxShadow: `0 6px 20px ${p.primary}50` }}>
              <Icon name="pin" size={20} stroke={2.2}/>
            </div>
            <span style={{ fontSize: 20, fontWeight: 700, color: p.ink, letterSpacing: -0.4 }}>Nearby</span>
          </div>
          <h1 style={{ fontSize: 28, fontWeight: 700, color: p.ink, letterSpacing: -0.6, margin: 0, lineHeight: 1.2 }}>
            {mode === 'signin' ? 'Welcome back.' : 'Make the neighborhood yours.'}
          </h1>
          <p style={{ fontSize: 15, color: p.inkSoft, marginTop: 8, marginBottom: 0, lineHeight: 1.45 }}>
            {mode === 'signin' ? 'Sign in to pick up where you left off.' : 'Create a free account to save places and build your list.'}
          </p>
        </div>
      </div>

      {/* Form */}
      <div style={{ flex: 1, padding: '24px 24px 20px', display: 'flex', flexDirection: 'column' }}>
        {field('Email', email, setEmail, 'email', 'email')}
        {field('Password', pwd, setPwd, 'pwd', 'password')}

        {mode === 'signin' && (
          <div style={{ textAlign: 'right', marginTop: -6, marginBottom: 14 }}>
            <a style={{ fontSize: 13, color: p.primary, fontWeight: 600, textDecoration: 'none' }}>Forgot?</a>
          </div>
        )}

        <button onClick={onSignIn} style={{
          padding: '15px 16px', background: p.primary, color: '#fff',
          border: 'none', borderRadius: 14, fontSize: 16, fontWeight: 700,
          fontFamily: TYPE.family, cursor: 'pointer', marginTop: 4,
          boxShadow: `0 10px 24px ${p.primary}35`, letterSpacing: 0.1,
        }}>
          {mode === 'signin' ? 'Sign in' : 'Create account'}
        </button>

        <div style={{ display: 'flex', alignItems: 'center', gap: 12, margin: '22px 0 16px' }}>
          <div style={{ flex: 1, height: 1, background: p.border }}/>
          <span style={{ fontSize: 12, color: p.inkFaint, fontWeight: 600, letterSpacing: 0.6 }}>OR</span>
          <div style={{ flex: 1, height: 1, background: p.border }}/>
        </div>

        <div style={{ display: 'flex', gap: 10 }}>
          {socialBtn('google', 'Google')}
          {socialBtn('apple', 'Apple')}
        </div>

        <div style={{ marginTop: 'auto', textAlign: 'center', fontSize: 14, color: p.inkSoft, paddingTop: 20 }}>
          {mode === 'signin' ? "Don't have an account? " : 'Already a member? '}
          <a onClick={() => setMode(mode === 'signin' ? 'signup' : 'signin')}
            style={{ color: p.primary, fontWeight: 700, cursor: 'pointer' }}>
            {mode === 'signin' ? 'Sign up' : 'Sign in'}
          </a>
        </div>
      </div>
    </div>
  );
}

window.LoginScreen = LoginScreen;
