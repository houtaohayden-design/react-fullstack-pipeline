# Swiper.js Design Tokens & Theming

> CSS variables, customization points, and styling approach for Swiper v12

## Architecture

Swiper uses a layered CSS architecture:

1. **Core styles** (`swiper.css`) — Structural layout, touch behavior, transitions. Required.
2. **Module styles** (`swiper/css/navigation`, `swiper/css/pagination`, etc.) — Optional, imported per-module.
3. **CSS custom properties** — Theme-color overrides via `--swiper-*` variables.
4. **Class-based customization** — All default class names are configurable via options.

All styles are imported individually for tree-shaking. No monolithic CSS file.

## CSS Custom Properties (Design Tokens)

```css
:root {
  /* Primary theme color — used by pagination bullets, navigation arrows, scrollbar, preloader */
  --swiper-theme-color: #007aff;

  /* Preloader spinner color (falls back to --swiper-theme-color) */
  --swiper-preloader-color: var(--swiper-theme-color);

  /* Wrapper transition timing function (defaults to browser default = ease) */
  --swiper-wrapper-transition-timing-function: initial;
}
```

### Usage Examples

**Override theme color:**
```css
:root {
  --swiper-theme-color: #6366f1;  /* indigo-500 */
}
```

**Override preloader color independently:**
```css
:root {
  --swiper-theme-color: #007aff;
  --swiper-preloader-color: #10b981;
}
```

**Custom easing for slide transitions:**
```css
:root {
  --swiper-wrapper-transition-timing-function: cubic-bezier(0.16, 1, 0.3, 1);
}
```

**Dark mode support:**
```css
[data-theme="dark"] {
  --swiper-theme-color: #818cf8;  /* indigo-400 */
}
```

### CSS Mode Variables (auto-populated)

When `cssMode: true`, Swiper sets these on the container:
- `--swiper-slides-offset-before` — Offset before first slide
- `--swiper-slides-offset-after` — Offset after last slide
- `--swiper-centered-offset-before` — Before offset when centeredSlides
- `--swiper-centered-offset-after` — After offset when centeredSlides

## Navigation Styling

### Default Structure

```html
<div class="swiper-button-prev"></div>
<div class="swiper-button-next"></div>
```

### CSS Classes

| Class | Purpose |
|-------|---------|
| `.swiper-button-prev` | Previous navigation button (default has SVG arrow icon) |
| `.swiper-button-next` | Next navigation button (default has SVG arrow icon) |
| `.swiper-button-disabled` | Added when button is disabled (at start/end) |
| `.swiper-button-hidden` | Added when button is hidden |
| `.swiper-button-lock` | Added when navigation is locked |

### Customization via Options

All class names configurable:
```js
navigation: {
  disabledClass: 'swiper-button-disabled',
  hiddenClass: 'swiper-button-hidden',
  lockClass: 'swiper-button-lock',
  navigationDisabledClass: 'swiper-navigation-disabled',
}
```

### Custom Arrow Styling

```css
.swiper-button-prev,
.swiper-button-next {
  color: var(--swiper-theme-color);
  width: 44px;
  height: 44px;
}

/* Hide default SVG, use custom background */
.swiper-button-prev::after,
.swiper-button-next::after {
  font-size: 24px;   /* Default icon size via font */
  font-weight: bold;
}
```

Set `addIcons: false` in navigation options to remove auto-added SVGs and use your own.

## Pagination Styling

### Bullets Structure

```html
<div class="swiper-pagination">
  <span class="swiper-pagination-bullet swiper-pagination-bullet-active"></span>
  <span class="swiper-pagination-bullet"></span>
</div>
```

### CSS Classes

| Class | Purpose |
|-------|---------|
| `.swiper-pagination` | Pagination container |
| `.swiper-pagination-bullet` | Individual bullet |
| `.swiper-pagination-bullet-active` | Active bullet |
| `.swiper-pagination-clickable` | Container when clickable |
| `.swiper-pagination-lock` | When locked/hidden |
| `.swiper-pagination-hidden` | Hidden state |
| `.swiper-pagination-horizontal` | Horizontal layout modifier |
| `.swiper-pagination-vertical` | Vertical layout modifier |
| `.swiper-pagination-current` | Current number (fraction type) |
| `.swiper-pagination-total` | Total number (fraction type) |
| `.swiper-pagination-progressbar-fill` | Progress bar fill element |

### Customization via Options

All class names configurable:
```js
pagination: {
  bulletClass: 'swiper-pagination-bullet',
  bulletActiveClass: 'swiper-pagination-bullet-active',
  bulletElement: 'span',     // HTML tag for bullet
  modifierClass: 'swiper-pagination-',
  currentClass: 'swiper-pagination-current',
  totalClass: 'swiper-pagination-total',
  hiddenClass: 'swiper-pagination-hidden',
  progressbarFillClass: 'swiper-pagination-progressbar-fill',
  clickableClass: 'swiper-pagination-clickable',
  lockClass: 'swiper-pagination-lock',
  horizontalClass: 'swiper-pagination-horizontal',
  verticalClass: 'swiper-pagination-vertical',
}
```

### Custom Bullet Styling

```css
.swiper-pagination-bullet {
  width: 8px;
  height: 8px;
  background: rgba(255, 255, 255, 0.5);
  opacity: 1;
  transition: all 0.3s ease;
}

.swiper-pagination-bullet-active {
  background: var(--swiper-theme-color);
  width: 24px;
  border-radius: 4px;  /* Pill shape for active */
}
```

### Dynamic Bullets Styling

When `dynamicBullets: true`:
- `.swiper-pagination-bullet-active-prev` — Previous bullet near active
- `.swiper-pagination-bullet-active-prev-prev` — Two before active
- `.swiper-pagination-bullet-active-next` — Next bullet near active
- `.swiper-pagination-bullet-active-next-next` — Two after active

## Scrollbar Styling

### Structure

```html
<div class="swiper-scrollbar">
  <div class="swiper-scrollbar-drag"></div>
</div>
```

### CSS Classes

| Class | Purpose |
|-------|---------|
| `.swiper-scrollbar` | Scrollbar track |
| `.swiper-scrollbar-drag` | Draggable thumb |
| `.swiper-scrollbar-lock` | Locked state |
| `.swiper-scrollbar-horizontal` | Horizontal modifier |
| `.swiper-scrollbar-vertical` | Vertical modifier |

### Customization via Options

```js
scrollbar: {
  lockClass: 'swiper-scrollbar-lock',
  dragClass: 'swiper-scrollbar-drag',
  scrollbarDisabledClass: 'swiper-scrollbar-disabled',
  horizontalClass: 'swiper-scrollbar-horizontal',
  verticalClass: 'swiper-scrollbar-vertical',
}
```

### Custom Scrollbar Styling

```css
.swiper-scrollbar {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  height: 4px;
}

.swiper-scrollbar-drag {
  background: var(--swiper-theme-color);
  border-radius: 10px;
}
```

## Slide Classes

Swiper automatically adds these classes to slides:

| Class | Condition |
|-------|-----------|
| `.swiper-slide-active` | Currently active slide |
| `.swiper-slide-visible` | Slide is visible in viewport |
| `.swiper-slide-fully-visible` | Entire slide visible |
| `.swiper-slide-next` | Next slide after active |
| `.swiper-slide-prev` | Previous slide before active |
| `.swiper-slide-blank` | Blank/placeholder slide in loop mode |
| `.swiper-slide-thumb-active` | Active thumb slide (Thumbs module) |
| `.swiper-slide-zoomed` | Currently zoomed slide (Zoom module) |

All class names are configurable:
```js
{
  slideClass: 'swiper-slide',
  slideBlankClass: 'swiper-slide-blank',
  slideActiveClass: 'swiper-slide-active',
  slideVisibleClass: 'swiper-slide-visible',
  slideFullyVisibleClass: 'swiper-slide-fully-visible',
  slideNextClass: 'swiper-slide-next',
  slidePrevClass: 'swiper-slide-prev',
  wrapperClass: 'swiper-wrapper',
}
```

## Transition Styling

The wrapper uses CSS `transition` for slide animations:

```css
.swiper-wrapper {
  transition-property: transform;
  transition-timing-function: var(--swiper-wrapper-transition-timing-function, initial);
}
```

You control transition duration via the `speed` option (default 300ms). The inline `transition-duration` is set dynamically by Swiper.

### Per-Slide Transition Duration

Not built-in, but achievable by setting `speed` dynamically in `slideChangeTransitionStart`:
```js
swiper.on('slideChangeTransitionStart', (s) => {
  const currentSlide = s.slides[s.activeIndex];
  const duration = currentSlide.dataset.duration || s.params.speed;
  s.wrapperEl.style.transitionDuration = `${duration}ms`;
});
```

## Container-Level Modifiers

Classes added to the Swiper container dynamically:

| Class | Condition |
|-------|-----------|
| `.swiper-initialized` | Swiper has initialized |
| `.swiper-horizontal` | Horizontal direction |
| `.swiper-vertical` | Vertical direction |
| `.swiper-rtl` | RTL mode |
| `.swiper-ltr` | LTR mode |
| `.swiper-android` | Android device |
| `.swiper-ios` | iOS device |
| `.swiper-css-mode` | CSS mode enabled |
| `.swiper-autoheight` | Auto-height enabled |
| `.swiper-3d` | 3D effect active |
| `.swiper-backface-hidden` | Backface visibility hidden |
| `.swiper-watch-progress` | Watch progress enabled |
| `.swiper-free-mode` | Free mode enabled |
| `.swiper-cards` | Cards effect active |
| `.swiper-creative` | Creative effect active |
| `.swiper-coverflow` | Coverflow effect active |
| `.swiper-cube` | Cube effect active |
| `.swiper-fade` | Fade effect active |
| `.swiper-flip` | Flip effect active |
| `.swiper-navigation-disabled` | Navigation disabled by breakpoint |
| `.swiper-pagination-disabled` | Pagination disabled by breakpoint |
| `.swiper-scrollbar-disabled` | Scrollbar disabled by breakpoint |

Container modifier class prefix is configurable: `containerModifierClass: 'swiper-'`

## Lazy Preloader

```css
.swiper-lazy-preloader {
  width: 42px;
  height: 42px;
  border: 4px solid var(--swiper-preloader-color, var(--swiper-theme-color));
  border-radius: 50%;
  border-top-color: transparent;
  animation: swiper-preloader-spin 1s infinite linear;
}
```

Color variants via classes:
- `.swiper-lazy-preloader-white` — Sets `--swiper-preloader-color: #fff`
- `.swiper-lazy-preloader-black` — Sets `--swiper-preloader-color: #000`

## 3D Shadow Gradients

Used by 3D effects (Coverflow, Cube, Cards, Creative when shadows enabled):

```css
.swiper-slide-shadow {
  background: rgba(0, 0, 0, 0.15);
}
.swiper-slide-shadow-left {
  background-image: linear-gradient(to left, rgba(0, 0, 0, 0.5), transparent);
}
.swiper-slide-shadow-right {
  background-image: linear-gradient(to right, rgba(0, 0, 0, 0.5), transparent);
}
.swiper-slide-shadow-top {
  background-image: linear-gradient(to top, rgba(0, 0, 0, 0.5), transparent);
}
.swiper-slide-shadow-bottom {
  background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0.5), transparent);
}
```

## CSS Mode Styling

When using `cssMode: true`, Swiper uses native CSS scroll-snap:

```css
.swiper-css-mode > .swiper-wrapper {
  overflow: auto;
  scrollbar-width: none;
  -ms-overflow-style: none;
}

.swiper-css-mode.swiper-horizontal > .swiper-wrapper {
  scroll-snap-type: x mandatory;
}

.swiper-css-mode > .swiper-wrapper > .swiper-slide {
  scroll-snap-align: start start;
}
```

## Theming Approach Summary

1. **Single CSS variable token**: `--swiper-theme-color` cascades to navigation, pagination, scrollbar, preloader
2. **Override in `:root` or themed context** (e.g., `[data-theme]`)
3. **Scoped theming**: Set on parent container for per-instance theming:
   ```css
   .hero-carousel {
     --swiper-theme-color: #ff6b35;
   }
   .product-carousel {
     --swiper-theme-color: #007aff;
   }
   ```
4. **Class names fully customizable** — Every CSS class Swiper uses is configurable in options
5. **No hard style dependencies** — Style arrows, bullets, scrollbar however you want; Swiper only handles positioning, visibility, and interaction
