# Handoff: Nearby — Local Business Discovery App

## Overview
Nearby is a mobile app for discovering local businesses. Users can browse a map of nearby places, switch to a list view with search/sort/filter, tap into a business detail page, and save favourites. The app launches with a login screen and a 4-screen onboarding wizard.

This package contains **high-fidelity design references built in HTML**. They are interactive prototypes, not production code. Your task is to **recreate these screens in Flutter** using the exact colours, typography, spacing, and interaction patterns documented here.

Open `Nearby.html` in a browser to interact with the full prototype. All 5 screens are live and clickable.

---

## Fidelity
**High-fidelity.** Pixel-precise colours, typography, spacing, border radii, and interactions are all finalised. Implement them exactly using Flutter widgets and the `app_theme.dart` file included in this package.

---

## Design Files in This Package

| File | Purpose |
|---|---|
| `Nearby.html` | Full interactive prototype — open in browser |
| `screens/login.jsx` | Login screen source |
| `screens/wizard.jsx` | Onboarding wizard source |
| `screens/map.jsx` | Map screen source |
| `screens/list.jsx` | List screen source |
| `screens/detail.jsx` | Business detail screen source |
| `tokens.jsx` | All design tokens (colours, type, data) |
| `map.jsx` | Branded map SVG component |
| `app_theme.dart` | Ready-to-use Flutter ThemeData + AppColors |
| `screenshots/` | PNG screenshots of every screen |

---

## Design Tokens

### Typography
- **Font family:** Inter (all weights). Add `google_fonts: ^6.x` to pubspec.yaml.
- **Display moments only:** Fraunces or Georgia serif (hero headlines if needed)

| Usage | Size | Weight | Letter spacing |
|---|---|---|---|
| Screen title (h1) | 28sp | 700 | -0.6 |
| Section header | 16sp | 700 | -0.2 |
| Business name (list) | 16sp | 700 | -0.2 |
| Business name (detail) | 28sp | 700 | -0.6 |
| Body / blurb | 15sp | 400 | 0 |
| Label / meta | 13sp | 500 | 0 |
| Chip / tag | 11–12sp | 600–700 | 0.2–0.4 |
| Button | 15–16sp | 700 | 0.1 |
| Status badge | 11sp | 700 | 0.4 |

### Colour Palettes
Three palettes are designed. **Start with Coral** (the default). All three are in `app_theme.dart`.

#### Coral (Default)
| Token | Hex | Usage |
|---|---|---|
| `primary` | `#F25D3A` | CTA buttons, active states, selected pins |
| `primaryDeep` | `#C9421F` | Button pressed state |
| `primarySoft` | `#FDD8C8` | Gradient backgrounds, hero tints |
| `accent` | `#2E8F88` | Stars/ratings, review avatars, fitness category |
| `bg` | `#F4D9C8` | Scaffold background — warm peach |
| `bgDeep` | `#EBC2A8` | Deeper background tones |
| `surface` | `#FFF8F1` | Cards, bottom sheets, input fields |
| `ink` | `#3A1F10` | Primary text |
| `inkSoft` | `#7A5540` | Secondary text |
| `inkFaint` | `#B89880` | Placeholder, disabled, meta text |
| `border` | `#E8C8B0` | Card borders, dividers, input borders |
| `chipBg` | `#F8E6D6` | Chip / tag backgrounds |
| `tint1` | `#F7C66B` | Services category |
| `tint2` | `#6FA8A0` | Bars category |
| `tint3` | `#8B6FBF` | Shops category |
| `tint4` | `#E87A9B` | Food/restaurant category |

#### Sage
| Token | Hex |
|---|---|
| `primary` | `#4F8A6E` |
| `accent` | `#D96A3E` |
| `bg` | `#D6E3CE` |
| `surface` | `#F5F8EF` |
| `ink` | `#1F2A20` |

#### Plum
| Token | Hex |
|---|---|
| `primary` | `#7A4EA8` |
| `accent` | `#E8A84A` |
| `bg` | `#E5D8EE` |
| `surface` | `#F7F2FA` |
| `ink` | `#2A1F35` |

### Category Colours (Coral palette)
| Category | Color token | Hex |
|---|---|---|
| Cafés | `primary` | `#F25D3A` |
| Food | `tint4` | `#E87A9B` |
| Shops | `tint3` | `#8B6FBF` |
| Services | `tint1` | `#F7C66B` |
| Fitness | `accent` | `#2E8F88` |
| Bars | `tint2` | `#6FA8A0` |

Category tiles use `softTint(color, 0.16)` — i.e. the color at 16% opacity as background, with a 22% opacity border.

### Spacing & Shape
| Token | Value |
|---|---|
| Card border radius | 16dp |
| Button border radius | 14dp |
| Input border radius | 12–14dp |
| Chip border radius | 20dp (pill) |
| Icon tile border radius | 10–14dp |
| Bottom sheet top radius | 24dp |
| Standard padding | 20dp horizontal |
| Card padding | 14dp |
| Section gap | 24dp |

### Shadows
- **Card:** `0 1px 3px rgba(0,0,0,0.05), 0 4px 12px rgba(0,0,0,0.06)` → Flutter: `BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0,4))`
- **Button (primary):** `0 10px 24px {primary}35` → elevation + colored shadow
- **Map controls:** `0 4px 12px rgba(0,0,0,0.10)`
- **Bottom nav:** top border `1px solid border` + blur backdrop

---

## Screen Specifications

### 1. Login Screen

**Layout:** `Column` — brand header (top ~40% of screen) + form (bottom ~60%)

**Brand header:**
- Background: linear gradient `170deg`, from `primarySoft` → `bg`
- App logo: 36×36dp rounded rect (radius 10), `primary` fill, white pin icon inside, shadow `0 6px 20px {primary}50`
- App name: "Nearby", 20sp, weight 700, `ink`, beside logo with 10dp gap
- Headline: 28sp, weight 700, `ink`, letter-spacing -0.6
- Subheadline: 15sp, `inkSoft`, line-height 1.45
- Decorative SVG circles at top-right and bottom-left corners, `primary` at 25% opacity

**Form section:**
- Padding: 24dp horizontal, 20dp bottom
- Labels: 12sp, weight 600, `inkSoft`, letter-spacing 0.2, margin-bottom 6dp
- Inputs: padding 14dp vertical / 16dp horizontal, 15sp, border 1.5dp solid `border`, radius 12dp, `surface` bg. On focus: border → `primary`, box-shadow `0 0 0 4px primarySoft`
- "Forgot?" link: 13sp, weight 600, `primary`, right-aligned
- Primary button: full width, 15dp vertical padding, `primary` bg, white text 16sp weight 700, radius 14dp, shadow `0 10px 24px {primary}35`
- OR divider: 1dp `border` lines, "OR" label 12sp weight 600 `inkFaint` letter-spacing 0.6
- Social buttons (Google + Apple): equal flex, 12dp vertical padding, 1.5dp `border`, `surface` bg, radius 12dp, 14sp weight 600
- Sign up toggle: 14sp `inkSoft` + `primary` weight 700 link

---

### 2. Onboarding Wizard (4 slides)

**Layout:** Full-screen `PageView` with 4 pages. Skip button top-right. Dots + CTA pinned to bottom.

**Slides:**
1. "Your neighborhood, in one place." — SVG map illustration
2. "Two views, one tap apart." — SVG showing map + list side-by-side
3. "Find exactly what you need." — SVG search/filter illustration
4. "Save the spots you love." — SVG bookmark/heart illustration

**Illustrations:** Abstract SVG shapes in palette colours — no photos, no emoji. See `screens/wizard.jsx` for exact SVG paths.

**Bottom controls:**
- Progress dots: active dot 24dp wide × 6dp tall, radius 3, `primary`. Inactive: 6×6dp, `border`. Animated width transition.
- Continue/Get Started button: full width, 15dp padding, `primary`, white 16sp weight 700, radius 14dp, shadow `0 10px 24px {primary}35`
- Skip: 14sp weight 600 `inkSoft`, top-right

---

### 3. Map Screen

**Layout:** Full-bleed map behind everything. Floating layers on top.

**Map:**
- Implement with `google_maps_flutter`
- Apply warm custom map style (generate at mapstyle.withgoogle.com using: land `#F4ECDF`, water `#CFE4E8`, roads white, parks `#DCE8C9`)
- Custom pin: teardrop shape, `surface` fill with `primary` stroke and inner dot when unselected; `primary` fill with white dot when selected. Selected pin is 1.35× scale with a pulsing halo.
- User location dot: blue `#2D7EF5` with white border and `primary` halo at 18% opacity

**Top floating layer:**
- Search bar: `surface` bg, radius 16dp, padding 12dp, shadow `0 4px 14px rgba(0,0,0,0.08)`. Search icon left, avatar right (28×28dp circle, `primary` bg, initials).
- Category chips below search: horizontal `ScrollView`, chips are pill-shaped (radius 20), 8×14dp padding. Active: `primary` or category tint fill, white text. Inactive: `surface` bg, `ink` text, subtle border.

**Right floating controls (top-right of map):**
- Layers button: 44×44dp, `surface`, radius 14dp, shadow
- Locate button: same + `primary` bg, white icon

**"List view" floating button:**
- Centered above bottom sheet: `ink` bg, white text + list icon, radius 24dp, shadow `0 6px 18px rgba(0,0,0,0.22)`

**Bottom sheet (selected business):**
- `DraggableScrollableSheet`, `surface` bg, top radius 24dp, shadow `0 -8px 24px rgba(0,0,0,0.08)`
- Drag handle: 40×4dp, `border`, centered, margin-bottom 14dp
- Business tile: 64×64dp icon tile (category tint at 16% opacity), business info, heart toggle
- Status badge: "OPEN" in `#0E8F5E` weight 700 / "CLOSED" in `inkFaint`, 11sp letter-spacing 0.4
- 3 action buttons: Directions (`primary` bg), Call, Share (both `chipBg` bg). Grid of 3, equal width, radius 12dp, icon + label stacked, 11sp weight 600
- "View details" button: full width, transparent, `border` stroke, radius 12dp, 14sp weight 600

---

### 4. List Screen

**Layout:** `Column` — sticky header (search + filters) + `ListView.builder`

**Header:**
- Scaffold bg: `bg` (peach/sage/lavender per palette)
- Title: "Nearby you" — 28sp weight 700 `ink`, letter-spacing -0.6
- Subtitle: count + location, 13sp `inkSoft`
- "Map" button (top-right): `primary` text, 14sp weight 700, map icon
- Search field: `surface` bg, 1.5dp `border`, radius 14dp, 11dp padding
- Sort button: pill, 1.5dp `border`, `surface` bg, sort icon + label + chevron, 13sp weight 600. Dropdown on tap: `surface` bg card, radius 12dp, shadow `0 8px 24px rgba(0,0,0,0.12)`. Active sort item bg: `chipBg`.
- Category chips: same as map screen
- Results count: 12sp `inkFaint` weight 600, right-aligned

**List cards:**
- Background: `surface`, radius 16dp, border `1dp border`, padding 14dp, gap 14dp
- Icon tile: 72×72dp, radius 14dp, category tint at 16% opacity, emoji icon centred, open dot (10dp green `#2DBB7A` bottom-right with white border)
- Business name: 16sp weight 700 `ink`
- Meta row: star icon in `accent` colour, rating in `ink` weight 600, review count/price/distance in `inkSoft`, 13sp
- Category chip: category tint colour text + background at 14% opacity, 11sp weight 700
- Tag chips: `chipBg` bg, `inkSoft` text, 11sp weight 600, radius 8dp
- Heart button: `inkFaint` → `primary` (filled) on toggle, top-right

---

### 5. Business Detail Screen

**Layout:** `CustomScrollView` with `SliverAppBar(expandedHeight: 260, pinned: true)`

**Hero (260dp tall):**
- Background: gradient using business hue (placeholder until real photos). In production: photo from API.
- Overlay top chrome: back button + share + bookmark — all 38×38dp circles, `rgba(255,255,255,0.92)` bg, `ink` icons, `backdropFilter: blur(12)`
- Bookmark filled: `primary` bg, white icon
- Photo count badge: bottom-right, `rgba(0,0,0,0.45)` bg, white text 12sp weight 600, radius 12dp, `backdropFilter: blur(8)`

**Header card (overlaps hero by 28dp via negative margin):**
- Bg: `bg`, top radius 24dp
- Category badge: category tint at 16% opacity bg, tint colour text, 12sp weight 700, radius 8dp
- Open/Closed badge: `#E6F7EE` bg + `#0E8F5E` text for open; `chipBg` + `inkSoft` for closed
- Business name: 28sp weight 700 `ink`, letter-spacing -0.6
- Rating row: `accent` star icon, rating in `ink` weight 700, reviews/price/distance in `inkSoft`, 14sp
- Blurb: 15sp `ink` at 85% opacity, line-height 1.5

**Quick actions (4-column grid):**
- Directions / Call / Website / Share
- Each: `surface` bg, `border` border 1dp, radius 12dp, icon in `primary` colour, label 12sp weight 600
- Padding 12dp vertical / 8dp horizontal

**Info rows card:**
- `surface` bg, radius 16dp, `border` border
- Each row: 36×36dp icon tile (`chipBg` bg, `primary` icon, radius 10dp) + title 14sp weight 600 + subtitle 12sp `inkFaint` + chevron
- Rows: Address, Hours, Website
- Divider between rows: 1dp `border`

**Photos grid:**
- 3-column CSS grid: first photo spans 2 rows (tall), others fill right column
- Each cell: gradient placeholder (real photos in production), radius 10dp
- "+19" overlay on last cell: `rgba(0,0,0,0.4)` bg, white 14sp weight 700

**Reviews section:**
- Rating summary: 38sp weight 700 `ink` + 5 stars in `accent` colour + count
- Review cards: avatar 28×28dp circle (`accent` at 18% opacity bg, `accent` text), name 14sp weight 600, date `inkFaint`, stars in `accent`
- Review text: 13.5sp `ink` at 80% opacity, indented 36dp from avatar

**Mini-map:**
- 140dp tall, radius 14dp, `border` border
- Same styled map, single pin for this business

**Sticky CTA bar (bottom, absolute positioned):**
- Gradient fade from transparent → `bg` over 86dp
- "Book a table" button: flex 1, `primary` bg, white 15sp weight 700, radius 14dp, shadow `0 10px 24px {primary}35`
- Directions button: 54dp wide, `ink` bg, white icon, radius 14dp

---

## Navigation & Routing

```
/login → /onboarding → /map (default tab)
                     → /list (tab 2)
                            ↓
                     /business/:id (detail)
                            ↓ back
                     /map or /list
```

**Bottom navigation bar** (visible on map + list only):
- 4 tabs: Map (map icon), Explore (list icon), Saved (bookmark icon), Profile (person icon)
- Active tab: `primary` colour, weight 700 label
- Inactive: `inkFaint`, weight 500 label
- Background: `rgba(surface, 0.94)` + blur backdrop
- Top border: 1dp `border`
- Height: ~80dp incl. safe area inset
- Tab label: 10.5sp

---

## Interactions & Animations

| Interaction | Behaviour |
|---|---|
| Input focus | Border → `primary`, box-shadow ring in `primarySoft`, 150ms ease |
| Primary button tap | Scale down 0.97, shadow reduces, 100ms |
| Category chip select | Background animates to tint colour, text → white, 200ms |
| Map pin select | Scale 1.0 → 1.35, pulsing halo fades in, 200ms ease-out |
| Bottom sheet | `DraggableScrollableSheet` min 0.32, max 1.0, initial 0.32 |
| Heart toggle | Scale bounce: 1.0 → 1.3 → 1.0, colour fill, 250ms |
| List → Map transition | `Hero` animation on selected business tile |
| Wizard dots | Width animated: 6dp → 24dp, 250ms ease |
| Sort dropdown | Fade + slide down 4dp, 150ms |

---

## State Management

Recommended: **Riverpod** (or Provider)

| Provider | Type | Purpose |
|---|---|---|
| `savedBusinessesProvider` | `StateProvider<Set<String>>` | Saved/favourited IDs |
| `selectedCategoryProvider` | `StateProvider<String?>` | Active category filter |
| `sortProvider` | `StateProvider<SortMode>` | distance / rating / name / price |
| `searchQueryProvider` | `StateProvider<String>` | Live search string |
| `selectedBusinessProvider` | `StateProvider<String?>` | Map pin selection |
| `businessRepositoryProvider` | `Provider<BusinessRepository>` | Data source abstraction |

---

## Data Model

```dart
class Business {
  final String id;
  final String name;
  final String category;  // 'cafe' | 'restaurant' | 'shop' | 'service' | 'fitness' | 'bar'
  final double rating;
  final int reviewCount;
  final String price;     // '$' | '$$' | '$$$'
  final String distance;  // e.g. '0.2 mi'
  final bool isOpen;
  final String closingTime;
  final String street;
  final String blurb;
  final List<String> tags;
  final LatLng coordinates;
}
```

Seed data is in `tokens.jsx` → `BUSINESSES` array. Start with a local JSON asset, wire to your backend later.

---

## Flutter Package Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1
  go_router: ^14.0.0
  google_maps_flutter: ^2.6.0
  riverpod: ^2.5.0       # or flutter_riverpod
  cached_network_image: ^3.3.0

dev_dependencies:
  flutter_lints: ^4.0.0
```

---

## Map Setup (Google Maps)

```swift
// ios/Runner/AppDelegate.swift
GMSServices.provideAPIKey("YOUR_IOS_API_KEY")
```

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_ANDROID_API_KEY"/>
```

Load warm map style from `assets/map_style.json` (generate at mapstyle.withgoogle.com):
```dart
_mapController.setMapStyle(
  await rootBundle.loadString('assets/map_style.json')
);
```

Custom pin — create via `BitmapDescriptor.fromAssetImage` with a teardrop SVG exported at 3× density.

---

## Assets Needed

| Asset | Description |
|---|---|
| `assets/map_style.json` | Warm Google Maps style |
| `assets/icons/pin.svg` | Teardrop map pin (unselected + selected states) |
| `assets/images/placeholder.png` | Business hero placeholder |

All icons are custom SVG line icons — see `tokens.jsx` → `Icon` component for the exact SVG paths. Recreate these as Flutter `CustomPainter` or export as SVG assets.

---

## Notes for Claude Code

1. **Start with `app_theme.dart`** — it's already written. Add it to your project.
2. **Stub all 5 screens first** as empty `Scaffold`s with correct routes, then flesh out one at a time.
3. **Port in this order:** Detail → List → Map → Wizard → Login (most complex first).
4. **The HTML prototype is interactive** — open `Nearby.html` in a browser to see exact hover states, transitions, and layout at every breakpoint.
5. **Category tinting:** everywhere a business tile appears, the icon container background is `categoryColor.withOpacity(0.16)` and border is `categoryColor.withOpacity(0.22)`.
6. **Bottom nav** only shows on Map and List routes — hide it on Login, Wizard, and Detail.
