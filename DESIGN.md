---
name: Discotheque
colors:
  surface: '#121317'
  surface-dim: '#121317'
  surface-bright: '#38393e'
  surface-container-lowest: '#0d0e12'
  surface-container-low: '#1a1b20'
  surface-container: '#1f1f24'
  surface-container-high: '#292a2e'
  surface-container-highest: '#343439'
  on-surface: '#e3e2e8'
  on-surface-variant: '#e5bcc5'
  inverse-surface: '#e3e2e8'
  inverse-on-surface: '#2f3035'
  outline: '#ac878f'
  outline-variant: '#5c3f46'
  surface-tint: '#ffb1c4'
  primary: '#ffb1c4'
  on-primary: '#65002e'
  primary-container: '#ff4a8d'
  on-primary-container: '#590028'
  inverse-primary: '#ba005b'
  secondary: '#d6baff'
  on-secondary: '#42008a'
  secondary-container: '#6201c5'
  on-secondary-container: '#caa9ff'
  tertiary: '#00dbe9'
  on-tertiary: '#00363a'
  tertiary-container: '#00a0aa'
  on-tertiary-container: '#002f33'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffd9e1'
  primary-fixed-dim: '#ffb1c4'
  on-primary-fixed: '#3f001a'
  on-primary-fixed-variant: '#8f0044'
  secondary-fixed: '#ecdcff'
  secondary-fixed-dim: '#d6baff'
  on-secondary-fixed: '#270057'
  on-secondary-fixed-variant: '#5f00c0'
  tertiary-fixed: '#7df4ff'
  tertiary-fixed-dim: '#00dbe9'
  on-tertiary-fixed: '#002022'
  on-tertiary-fixed-variant: '#004f54'
  background: '#121317'
  on-background: '#e3e2e8'
  surface-variant: '#343439'
typography:
  display-hero:
    fontFamily: Space Grotesk
    fontSize: 56px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.03em
  display-hero-mobile:
    fontFamily: Space Grotesk
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-xl:
    fontFamily: Space Grotesk
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Space Grotesk
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Space Grotesk
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Space Grotesk
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.04em
  label-md:
    fontFamily: Space Grotesk
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-caps:
    fontFamily: Space Grotesk
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.1em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-mobile: 0.75rem
  margin: 2rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

### Personality & Emotional Response
The design system channels an intimate, nocturnal energy: a high-fidelity listening lounge submerged in late-night neon. It reconciles analog tactile warmth (grooved vinyl discs, needle drops, physical playback controls) with an ultra-sleek retro-futuristic digital interface. The experience evokes cinematic exclusivity, curatorial focus, and collaborative nocturnal discovery.

### Aesthetic Paradigm
- **Neon Dark Mode / Vinyl Club**: The foundational canvas rests in deep obsidian and rich graphite, creating an abyss from which high-frequency neon accents—hot magenta, electric purple, and piercing cyan—radiate with purposeful glow effects.
- **Controlled Glassmorphism**: Translucent surfaces make use of heavy backdrop blurs (`backdrop-filter: blur(16px)` to `blur(24px)`) and delicate perimeter rim lighting rather than milky washes, maintaining contrast and legibility across all layers.
- **Micro-tactile Analog Accents**: Micro-interactions reference analog hifi hardware—concentric grooved vinyl textures, stepped rotary volume nodes, and physical switch states—rendered with modern, precision vector styling.

## Colors

### Palette System
- **Canvas Base (`#0B0C10`)**: The deepest obsidian black, reserved for root backgrounds and peripheral canvas margins.
- **Surface Elevation 1 (`#13151B`)**: Graphite foundation for sidebars, persistent panels, and bottom music docks.
- **Surface Elevation 2 (`#1F2833`)**: Interactive card backgrounds, module enclosures, and input containers.
- **Primary Accent (`#FF007F`)**: Neon Magenta. Used for active playback triggers, primary call-to-actions, live indicators, and peak audio meters.
- **Secondary Accent (`#6F22D2`)**: Electric Purple. Powers gradient transitions, collaborative session badges, and secondary atmospheric fills.
- **Tertiary Accent (`#00F0FF`)**: Bright Cyan. Denotes system precision, track progress handles, active collaborative cursors, and lossless audio indicators.

### Foreground & Typography Colors
- **Text Primary (`#FFFFFF`)**: High contrast, crisp headers, track titles, and active iconography.
- **Text Secondary (`#C5C6C7`)**: Muted metadata, artist tags, duration counters, and table headers.
- **Text Tertiary (`#666B73`)**: Disabled elements, subtle borders, and background grid lines.

### Functional Lighting Application
Neon accents must never be used as solid background fills over large areas. Apply neon colors to text, active strokes, glowing badges, audio visualizers, and linear gradients (`linear-gradient(135deg, #FF007F 0%, #6F22D2 100%)`).

## Typography

### Structural Pairings
- **Display & Headlines (`Space Grotesk`)**: Provides an electro-futuristic structure with distinct geometric incisions. Reserved for track titles, playlist headers, visualizer readouts, and navigation links.
- **Body & Secondary Copy (`Manrope`)**: Delivers neutral, highly legible sans-serif metrics optimized for scanning dense music tables, metadata groupings, queue listings, and credits.
- **Labels & Micro-data (`Space Grotesk`)**: Uppercase labels maintain precision instrumentation formatting across playback stats (e.g., `44.1 KHZ / 24-BIT`, `BPM 124`).

### Hierarchy & Responsive Scaling
Headlines scale down fluidly on screens narrower than `768px` using the designated `-mobile` alternatives to prevent line-wrapping errors over album hero banners. Always maintain strict tabular figures (`font-variant-numeric: tabular-nums`) for track durations, BPM, and scrub timers to prevent optical layout jitter.

## Layout & Spacing

### Layout Architecture
- **Desktop (1024px+)**: A 12-column asymmetric layout structured around three distinct operational planes:
  1. *Left Navigation Hub* (240px fixed width): Library, collaborative rooms, custom crates.
  2. *Central Exploration Zone* (fluid flex-column): Dynamic grid showcasing playlists, album release art, and collaborative listening channels.
  3. *Right Vinyl Console* (320px fixed width): Current track spinning visualization, live queue, user avatars, and room chat.
  4. *Persistent Dock* (90px height fixed at viewport bottom): Global player controls, scrubber, and audio output options.
- **Tablet (768px - 1023px)**: Left hub collapses to an icon-only dock (64px width); right console folds into a slide-over drawer triggered from the bottom playback bar.
- **Mobile (<768px)**: Fluid single-column layout. Top navigation condensed to minimalist room switcher. The persistent player bar anchors to the bottom with an expandable swipe-up modal for full vinyl turntable interactions and collaborative controls.

### Density & Rhythms
The system utilizes an 8px base rhythm. Spacing around album art and grid modules must prioritize optical balance: tight internal card spacing (`space-sm` to `space-md`) contrasted with airy, structured section dividers (`space-xl`).

## Elevation & Depth

### Atmospheric Stacking Model
Depth is constructed through optical transmission rather than opaque elevation drops:

1. **Floor (Canvas)**: `#0B0C10` baseline. Subtly infused with fixed radial gradient glows (`radial-gradient(circle at 80% 20%, rgba(111, 34, 210, 0.15) 0%, transparent 50%)`).
2. **Surface Tier 1 (Module Ground)**: `#13151B` at `85%` opacity with `backdrop-filter: blur(16px)` and a hairline outline (`1px solid rgba(255, 255, 255, 0.06)`).
3. **Surface Tier 2 (Floating Cards & Flyouts)**: `#1F2833` at `70%` opacity, `backdrop-filter: blur(20px)`, and subtle rim lighting (`1px solid rgba(255, 0, 127, 0.2)` on hover).
4. **Surface Tier 3 (Modals, Overlays, and Persistent Dock)**: `#0B0C10` at `92%` opacity with `backdrop-filter: blur(28px)`, flanked by top borders bearing subtle neon gradient strokes.

### Neon Luminescence & Shadow Signatures
- **Ambient Shadow**: `0 12px 32px -4px rgba(0, 0, 0, 0.7)` for neutral elevation.
- **Neon Glow (Magenta)**: `0 0 20px -2px rgba(255, 0, 127, 0.45)`, reserved for playing vinyl discs, live badges, and active toggle states.
- **Neon Glow (Cyan)**: `0 0 16px -2px rgba(0, 240, 255, 0.4)`, used for active audio scrubber heads and interactive sliders.
- **Rim-Lighting Principle**: Borders on elevated interactive elements are directional—brighter at the top edge (`rgba(255, 255, 255, 0.12)`) and fading at the bottom (`rgba(255, 255, 255, 0.02)`), simulating ambient top-down club spotlights.

## Shapes

### Geometry & Curvature
- Standard containers, audio cards, and module blocks adopt a balanced rounded corner standard (`0.5rem` or `8px`), maintaining a crisp, architectural finish that feels modern without drifting into bubbly softness.
- Elevated panels and modal sheets utilize `rounded-lg` (`1rem` / `16px`).
- Interactive pills, badges, volume scrub handles, and play/pause controls leverage full circular geometry (`rounded-full` / `9999px`) to contrast against rectangular grid modules.
- **Vinyl Grooves**: Vinyl records and center label art must strictly maintain a 1:1 circular ratio with concentric masking layers to house circular SVG grooving lines.

## Components

### Buttons
- **Primary Play Button**: Full circle (`rounded-full`), filled with solid `#FF007F` or a dual gradient (`#FF007F` to `#6F22D2`). Active states emit an instant outer glow (`box-shadow: 0 0 24px rgba(255, 0, 127, 0.6)`). Icon is crisp white, optically centered.
- **Secondary Action**: Background `#1F2833` with `1px solid rgba(255, 255, 255, 0.1)`. On hover, border shifts to `#00F0FF` with text tinted cyan.
- **Ghost Action**: Transparent background with neutral secondary text (`#C5C6C7`). On hover, text brightens to `#FFFFFF` with an ambient glow.

### Interactive Music Track Row
- Grid row containing: Track sequence / Animated waveform equalizer, Title + Artist, Album, Collaborative Adder Avatar, and Duration.
- Hover state: Background shifts to `rgba(255, 255, 255, 0.04)` with a smooth `border-left: 2px solid #FF007F`.
- Playing state: Track title shifts to `#00F0FF`, and the track index is replaced by an animated 3-bar cyan visualizer.

### Vinyl Spinning Player Module
- Displays album jacket alongside an extruded spinning vinyl record with light-reflective sheen.
- State: When playing, the vinyl rotates continuously (`animation: spin 3.5s linear infinite`). When paused, the disc gently decelerates over 800ms and recedes slightly back into the jacket sleeve.
- Center spindle contains the micro album badge encircled by metallic micro-typography indicating playback RPM.

### Interactive Scrubbers & Sliders
- **Track Time Bar**: 4px track height in `#1F2833`. Progress fill is styled with an electric gradient (`#6F22D2` to `#00F0FF`).
- **Scrubber Node**: Appears on hover as a 12px pill in `#00F0FF` with a cyan drop shadow (`box-shadow: 0 0 10px #00F0FF`).

### Chips & Badges
- **Live Room Badge**: Pill container with black fill, bordered in `rgba(255, 0, 127, 0.4)`. Features a pulsing neon magenta LED indicator (`@keyframes pulse`) and `label-caps` typography.
- **Genre / Mood Pill**: `#13151B` background, subtle rounded corners (`rounded-full`), `space-xs` vertical and `space-sm` horizontal padding. Hover activates cyan rim glow.

### Form Inputs & Search Fields
- Enclosed with `#13151B` background and `1px solid rgba(255, 255, 255, 0.08)`.
- Internal prefix icon (magnifying glass) in `#C5C6C7`.
- Focus state: Border transitions to `#6F22D2` accompanied by a localized neon haze (`box-shadow: 0 0 14px rgba(111, 34, 210, 0.35)`). Text is rendered in `#FFFFFF`.

### Checkboxes & Toggles
- Custom radios and checkboxes feature `#1F2833` frame. Checked state fills with `#FF007F` and white check icon.
- Collaborative Sync Toggle: Pill track switches between dark graphite `#1F2833` (off) and cyan `#00F0FF` (synced), smoothly sliding the circular switch handle.