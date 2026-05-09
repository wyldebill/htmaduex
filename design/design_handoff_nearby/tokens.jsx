// Nearby — design tokens + tiny UI primitives
// Warm, friendly coral palette on cream. Uses Inter-like system stack.
// Three palettes exposed via window.__palette (set by Tweaks); default is Coral.

const PALETTES = {
  Coral: {
    name: 'Coral',
    primary: '#F25D3A',      // coral accent
    primaryDeep: '#C9421F',
    primarySoft: '#FDD8C8',
    accent: '#2E8F88',       // secondary — deep teal, complementary to coral
    accentSoft: '#D4EAE7',
    bg: '#F4D9C8',           // deeper peach — saturated background
    bgDeep: '#EBC2A8',
    surface: '#FFF8F1',      // warm off-white cards
    ink: '#3A1F10',
    inkSoft: '#7A5540',
    inkFaint: '#B89880',
    border: '#E8C8B0',
    chipBg: '#F8E6D6',
    tint1: '#F7C66B',        // mustard
    tint2: '#6FA8A0',        // teal
    tint3: '#8B6FBF',        // plum
    tint4: '#E87A9B',        // pink
    mapLand: '#F4ECDF',
    mapWater: '#CFE4E8',
    mapRoad: '#FFFFFF',
    mapRoadAlt: '#EADFCC',
    mapPark: '#DCE8C9',
  },
  Sage: {
    name: 'Sage',
    primary: '#4F8A6E',
    primaryDeep: '#2F6049',
    primarySoft: '#CFE0C8',
    accent: '#D96A3E',       // warm coral, complementary to sage
    accentSoft: '#FADFD2',
    bg: '#D6E3CE',           // deeper sage background
    bgDeep: '#C0D4B8',
    surface: '#F5F8EF',
    ink: '#1F2A20',
    inkSoft: '#5B6860',
    inkFaint: '#8A9A8E',
    border: '#BFD4B5',
    chipBg: '#E3EEDA',
    tint1: '#E8A860',
    tint2: '#5B8CA6',
    tint3: '#A07AB0',
    tint4: '#D96A3E',
    mapLand: '#EEEEE1',
    mapWater: '#C8DDE0',
    mapRoad: '#FFFFFF',
    mapRoadAlt: '#E2DCCB',
    mapPark: '#D4E0BF',
  },
  Plum: {
    name: 'Plum',
    primary: '#7A4EA8',
    primaryDeep: '#53307C',
    primarySoft: '#DCCBE8',
    accent: '#E8A84A',       // golden mustard, complementary to plum
    accentSoft: '#F7E9C9',
    bg: '#E5D8EE',           // deeper lavender background
    bgDeep: '#D4C2E0',
    surface: '#F7F2FA',
    ink: '#2A1F35',
    inkSoft: '#655A6F',
    inkFaint: '#9A8FA6',
    border: '#D2C0DD',
    chipBg: '#ECE0F2',
    tint1: '#E8B14E',
    tint2: '#539596',
    tint3: '#C96D8C',
    tint4: '#5E8FC2',
    mapLand: '#F1EBE3',
    mapWater: '#D4DDE2',
    mapRoad: '#FFFFFF',
    mapRoadAlt: '#E7DFD0',
    mapPark: '#D9E1C6',
  },
};

// Hook to read current palette from window + trigger re-render on change.
function usePalette() {
  const [p, setP] = React.useState(window.__paletteName || 'Coral');
  React.useEffect(() => {
    const onChange = () => setP(window.__paletteName || 'Coral');
    window.addEventListener('__paletteChanged', onChange);
    return () => window.removeEventListener('__paletteChanged', onChange);
  }, []);
  return PALETTES[p] || PALETTES.Coral;
}

const TYPE = {
  family: '"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif',
  display: '"Fraunces", "Cooper", Georgia, serif', // reserved for hero moments only
  mono: '"JetBrains Mono", ui-monospace, Menlo, monospace',
};

// ─────────────────────────────────────────────────────────────
// Mock business data (seeded, varied categories)
// ─────────────────────────────────────────────────────────────
// Category colors use palette tints so they restyle with palette changes.
// `tintKey` resolves from the active palette at render time.
const CATEGORIES = [
  { id: 'cafe',       label: 'Cafés',    icon: '☕',  tintKey: 'primary' },
  { id: 'restaurant', label: 'Food',     icon: '🍜', tintKey: 'tint4' },
  { id: 'shop',       label: 'Shops',    icon: '🛍', tintKey: 'tint3' },
  { id: 'service',    label: 'Services', icon: '✂️', tintKey: 'tint1' },
  { id: 'fitness',    label: 'Fitness',  icon: '💪', tintKey: 'accent' },
  { id: 'bar',        label: 'Bars',     icon: '🍷', tintKey: 'tint2' },
];

// Convert any hex to a soft tinted background
function softTint(hex, alpha = 0.18) {
  const m = hex.replace('#', '');
  const r = parseInt(m.slice(0, 2), 16);
  const g = parseInt(m.slice(2, 4), 16);
  const b = parseInt(m.slice(4, 6), 16);
  return `rgba(${r},${g},${b},${alpha})`;
}

const BUSINESSES = [
  { id: 1, name: 'Driftwood Coffee', cat: 'cafe', rating: 4.8, reviews: 312, price: '$$', dist: '0.2 mi', open: true, closeTime: '7:00 PM', street: '218 Elm St', tags: ['Outdoor', 'Pet-friendly', 'Wi-Fi'], blurb: 'Neighborhood third-wave café with single-origin pours and sourdough toasts.', x: 52, y: 38, hue: 18 },
  { id: 2, name: 'Pine & Palm Bookshop', cat: 'shop', rating: 4.9, reviews: 86, price: '$$', dist: '0.4 mi', open: true, closeTime: '8:00 PM', street: '14 Cedar Lane', tags: ['Local', 'Events'], blurb: 'Independent bookstore with a curated travel section and weekly readings.', x: 28, y: 58, hue: 280 },
  { id: 3, name: 'Tokio Ramen Bar', cat: 'restaurant', rating: 4.6, reviews: 1204, price: '$$', dist: '0.6 mi', open: true, closeTime: '10:00 PM', street: '902 Market St', tags: ['Dine-in', 'Takeout'], blurb: 'Rich tonkotsu broth, handmade noodles, and a tight menu of seasonal specials.', x: 70, y: 52, hue: 8 },
  { id: 4, name: 'Harbor Barber', cat: 'service', rating: 4.7, reviews: 228, price: '$$', dist: '0.3 mi', open: false, closeTime: 'Closed', street: '47 Wharf St', tags: ['Walk-ins', 'By appt.'], blurb: 'Old-school cuts and hot-towel shaves from three generations of barbers.', x: 40, y: 26, hue: 170 },
  { id: 5, name: 'Rosemary Florist', cat: 'shop', rating: 5.0, reviews: 64, price: '$$$', dist: '0.8 mi', open: true, closeTime: '6:30 PM', street: '331 Vine St', tags: ['Delivery', 'Weddings'], blurb: 'Seasonal bouquets, dried arrangements, and same-day local delivery.', x: 58, y: 70, hue: 335 },
  { id: 6, name: 'Iron & Oak Gym', cat: 'fitness', rating: 4.5, reviews: 419, price: '$$', dist: '1.1 mi', open: true, closeTime: '11:00 PM', street: '1200 Industrial Ave', tags: ['24/7', 'Classes'], blurb: 'Strength-focused gym with Olympic platforms and bootcamp classes.', x: 82, y: 32, hue: 220 },
  { id: 7, name: 'Plume Wine Bar', cat: 'bar', rating: 4.8, reviews: 541, price: '$$$', dist: '0.5 mi', open: true, closeTime: '1:00 AM', street: '56 Gallery Row', tags: ['Natural wine', 'Small plates'], blurb: 'Natural wines by the glass and a rotating cast of small plates.', x: 48, y: 64, hue: 310 },
  { id: 8, name: 'Lumen Photo Lab', cat: 'service', rating: 4.9, reviews: 97, price: '$$', dist: '0.9 mi', open: true, closeTime: '7:00 PM', street: '78 Harbor Dr', tags: ['Film', 'Scans'], blurb: 'Full film-developing lab with hi-res scans and darkroom rentals.', x: 22, y: 44, hue: 50 },
  { id: 9, name: 'Moss Matcha', cat: 'cafe', rating: 4.7, reviews: 188, price: '$$', dist: '0.7 mi', open: true, closeTime: '6:00 PM', street: '512 Lotus Ln', tags: ['Vegan', 'Outdoor'], blurb: 'Ceremonial-grade matcha, seasonal lattes, and mochi from a local maker.', x: 36, y: 76, hue: 120 },
  { id: 10, name: 'Field Notes Cycles', cat: 'shop', rating: 4.8, reviews: 142, price: '$$$', dist: '1.3 mi', open: true, closeTime: '7:00 PM', street: '88 Willow Way', tags: ['Repairs', 'Rentals'], blurb: 'Curated cycle shop with rentals, tune-ups, and weekend group rides.', x: 64, y: 22, hue: 200 },
];

// Simple monochrome line icons so we avoid emoji in the chrome.
// Each returns an SVG; color via currentColor.
const Icon = ({ name, size = 20, stroke = 1.8 }) => {
  const s = { width: size, height: size, fill: 'none', stroke: 'currentColor', strokeWidth: stroke, strokeLinecap: 'round', strokeLinejoin: 'round' };
  switch (name) {
    case 'map': return <svg viewBox="0 0 24 24" {...s}><path d="M9 4L3 6v14l6-2 6 2 6-2V4l-6 2-6-2z"/><path d="M9 4v14M15 6v14"/></svg>;
    case 'list': return <svg viewBox="0 0 24 24" {...s}><path d="M8 6h13M8 12h13M8 18h13"/><circle cx="3.5" cy="6" r="1"/><circle cx="3.5" cy="12" r="1"/><circle cx="3.5" cy="18" r="1"/></svg>;
    case 'saved': return <svg viewBox="0 0 24 24" {...s}><path d="M6 3h12v18l-6-4-6 4V3z"/></svg>;
    case 'profile': return <svg viewBox="0 0 24 24" {...s}><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-7 8-7s8 3 8 7"/></svg>;
    case 'search': return <svg viewBox="0 0 24 24" {...s}><circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/></svg>;
    case 'filter': return <svg viewBox="0 0 24 24" {...s}><path d="M3 5h18M6 12h12M10 19h4"/></svg>;
    case 'sort': return <svg viewBox="0 0 24 24" {...s}><path d="M7 4v16M3 8l4-4 4 4M17 20V4M13 16l4 4 4-4"/></svg>;
    case 'star': return <svg viewBox="0 0 24 24" {...s} fill="currentColor" stroke="none"><path d="M12 2l3 7 7 .7-5.3 4.8 1.7 7L12 17.8 5.6 21.5l1.7-7L2 9.7 9 9z"/></svg>;
    case 'pin': return <svg viewBox="0 0 24 24" {...s}><path d="M12 22s7-6.5 7-13a7 7 0 10-14 0c0 6.5 7 13 7 13z"/><circle cx="12" cy="9" r="2.5"/></svg>;
    case 'call': return <svg viewBox="0 0 24 24" {...s}><path d="M5 4h4l2 5-3 2a12 12 0 006 6l2-3 5 2v4a2 2 0 01-2 2A16 16 0 013 6a2 2 0 012-2z"/></svg>;
    case 'dir': return <svg viewBox="0 0 24 24" {...s}><path d="M12 2l10 10-10 10L2 12 12 2z"/><path d="M8 12h7v-3l5 4-5 4v-3H8z"/></svg>;
    case 'web': return <svg viewBox="0 0 24 24" {...s}><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 010 18M12 3a14 14 0 000 18"/></svg>;
    case 'clock': return <svg viewBox="0 0 24 24" {...s}><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/></svg>;
    case 'share': return <svg viewBox="0 0 24 24" {...s}><circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="6" r="2.5"/><circle cx="18" cy="18" r="2.5"/><path d="M8.5 11l7-4M8.5 13l7 4"/></svg>;
    case 'bookmark': return <svg viewBox="0 0 24 24" {...s}><path d="M6 3h12v18l-6-4-6 4V3z"/></svg>;
    case 'bookmarkFill': return <svg viewBox="0 0 24 24" {...s} fill="currentColor"><path d="M6 3h12v18l-6-4-6 4V3z"/></svg>;
    case 'back': return <svg viewBox="0 0 24 24" {...s}><path d="M15 6l-6 6 6 6"/></svg>;
    case 'close': return <svg viewBox="0 0 24 24" {...s}><path d="M6 6l12 12M18 6l-12 12"/></svg>;
    case 'chev': return <svg viewBox="0 0 24 24" {...s}><path d="M9 6l6 6-6 6"/></svg>;
    case 'chevDown': return <svg viewBox="0 0 24 24" {...s}><path d="M6 9l6 6 6-6"/></svg>;
    case 'layers': return <svg viewBox="0 0 24 24" {...s}><path d="M12 3l9 5-9 5-9-5 9-5zM3 13l9 5 9-5M3 17l9 5 9-5"/></svg>;
    case 'locate': return <svg viewBox="0 0 24 24" {...s}><circle cx="12" cy="12" r="4"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3"/></svg>;
    case 'plus': return <svg viewBox="0 0 24 24" {...s}><path d="M12 5v14M5 12h14"/></svg>;
    case 'heart': return <svg viewBox="0 0 24 24" {...s}><path d="M12 20s-7-4.5-9-9.5C1.5 6 6 2 9 5l3 3 3-3c3-3 7.5 1 6 5.5C19 15.5 12 20 12 20z"/></svg>;
    case 'heartFill': return <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 20s-7-4.5-9-9.5C1.5 6 6 2 9 5l3 3 3-3c3-3 7.5 1 6 5.5C19 15.5 12 20 12 20z"/></svg>;
    case 'google': return <svg viewBox="0 0 24 24" width={size} height={size}><path fill="#4285F4" d="M22 12.2c0-.7-.1-1.4-.2-2H12v3.8h5.6c-.2 1.3-1 2.3-2 3v2.5h3.3c2-1.8 3.1-4.5 3.1-7.3z"/><path fill="#34A853" d="M12 22c2.7 0 5-.9 6.7-2.4l-3.3-2.5c-.9.6-2 1-3.4 1-2.6 0-4.8-1.7-5.6-4.1H3v2.6A10 10 0 0012 22z"/><path fill="#FBBC05" d="M6.4 14c-.2-.6-.3-1.3-.3-2s.1-1.4.3-2V7.3H3a10 10 0 000 9.3L6.4 14z"/><path fill="#EA4335" d="M12 5.9c1.5 0 2.8.5 3.8 1.5l2.9-2.9A10 10 0 003 7.3L6.4 10c.8-2.4 3-4.1 5.6-4.1z"/></svg>;
    case 'apple': return <svg viewBox="0 0 24 24" width={size} height={size} fill="currentColor"><path d="M16.4 12.6c0-2.4 2-3.5 2-3.6-1.1-1.6-2.8-1.8-3.4-1.8-1.5-.1-2.8.8-3.6.8-.7 0-1.9-.8-3.1-.8-1.6 0-3 .9-3.8 2.4-1.6 2.8-.4 7 1.2 9.3.8 1.1 1.7 2.4 2.9 2.4 1.2 0 1.6-.8 3-.8s1.8.8 3 .7c1.2 0 2-1.1 2.8-2.2 1-1.3 1.3-2.5 1.4-2.6-.1 0-2.7-1-2.4-4zm-2.4-7c.6-.8 1.1-1.8 1-2.9-.9 0-2 .6-2.7 1.4-.6.7-1.2 1.8-1 2.9 1 .1 2-.5 2.7-1.4z"/></svg>;
    case 'sparkle': return <svg viewBox="0 0 24 24" {...s}><path d="M12 2l1.5 5.5L19 9l-5.5 1.5L12 16l-1.5-5.5L5 9l5.5-1.5L12 2z"/></svg>;
    case 'book': return <svg viewBox="0 0 24 24" {...s}><path d="M4 4h6a3 3 0 013 3v13a2 2 0 00-2-2H4V4zM20 4h-6a3 3 0 00-3 3v13a2 2 0 012-2h7V4z"/></svg>;
    default: return null;
  }
};

Object.assign(window, { PALETTES, usePalette, TYPE, CATEGORIES, BUSINESSES, Icon, softTint });
