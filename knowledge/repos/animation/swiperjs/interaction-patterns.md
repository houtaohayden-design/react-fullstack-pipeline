# Swiper.js Interaction Patterns

> Touch gestures, navigation controls, transition effects, and control interactions

## Touch / Swipe Gestures

Swiper provides 1:1 touch movement by default. Touch behavior is highly configurable.

### Core Touch Physics

```js
const swiper = new Swiper('.swiper', {
  touchRatio: 1,        // 1:1 touch-to-move ratio
  touchAngle: 45,        // Max angle (deg) to trigger horizontal swipe
  simulateTouch: true,   // Mouse events simulate touch
  followFinger: true,    // Slide tracks finger position
  threshold: 5,          // Minimum px to start swipe
  shortSwipes: true,     // Allow quick flicks
  longSwipes: true,      // Allow long drags to change slide
  longSwipesRatio: 0.5,  // Ratio of slide width for long swipe threshold
  longSwipesMs: 300,     // Min duration for long swipe (ms)
});
```

### Resistance at Edges

```js
const swiper = new Swiper('.swiper', {
  resistance: true,        // Bounce back at edges
  resistanceRatio: 0.85,   // 85% of normal movement at edge (feels heavier)
  touchReleaseOnEdges: false,
});
```

### Edge Swipe Detection (iOS-style swipe-to-go-back)

```js
const swiper = new Swiper('.swiper', {
  edgeSwipeDetection: true,   // Detect swipe from screen edge
  edgeSwipeThreshold: 20,     // Edge zone width (px)
});
```

### Prevent Swipe on Overlapping Interactive Elements

```js
const swiper = new Swiper('.swiper', {
  noSwiping: true,
  noSwipingClass: 'swiper-no-swiping',  // class to disable swipe on
  noSwipingSelector: 'button, input',   // selector to disable swipe on
  focusableElements: 'input, select, textarea, button, video',
});
```

### Free Mode (Momentum Scrolling)

```js
const swiper = new Swiper('.swiper', {
  freeMode: {
    enabled: true,
    momentum: true,              // Keep sliding after release
    momentumRatio: 1,            // Distance multiplier
    momentumVelocityRatio: 1,    // Velocity multiplier
    momentumBounce: true,        // Bounce back at edges
    momentumBounceRatio: 1,      // Bounce intensity
    minimumVelocity: 0.02,       // Min velocity to trigger momentum
    sticky: false,               // Snap to slides when false
  },
});
```

## Mousewheel Control

```js
const swiper = new Swiper('.swiper', {
  mousewheel: {
    enabled: true,
    forceToAxis: false,      // Lock to axis only
    releaseOnEdges: true,    // Pass scroll to page when at edge
    invert: true,            // Reverse direction (natural scroll)
    sensitivity: 1,          // Mousewheel sensitivity multiplier
    eventsTarget: 'container', // 'container', 'wrapper', or CSS selector/HTMLElement
    thresholdDelta: null,    // Min delta to trigger
    thresholdTime: null,     // Min time between triggers (ms)
    noMousewheelClass: 'swiper-no-mousewheel',
  },
});
```

**Events:** `scroll` event fires on mousewheel scroll with `(swiper, WheelEvent)`.

## Keyboard Navigation

```js
const swiper = new Swiper('.swiper', {
  keyboard: {
    enabled: true,
    onlyInViewport: true,    // Only control when Swiper is visible
    pageUpDown: true,        // Enable Page Up / Page Down keys
    speed: undefined,        // Override transition speed (optional)
  },
});
```

**Keys:** Arrow Left/Up = prev, Arrow Right/Down = next, Page Up = prev, Page Down = next.

**Events:** `keyPress` event fires with `(swiper, keyCode)`.

## Autoplay with Interaction Behavior

```js
const swiper = new Swiper('.swiper', {
  autoplay: {
    delay: 3000,                     // 3 seconds per slide
    stopOnLastSlide: false,          // Don't stop at last slide
    disableOnInteraction: true,      // Pause after user swipe (default: true)
    reverseDirection: false,         // Auto-play in reverse
    waitForTransition: true,         // Wait for transition to finish
    pauseOnMouseEnter: false,        // Pause on hover
  },
});
```

**Per-slide autoplay duration (HTML attribute):**
```html
<div class="swiper-slide" data-swiper-autoplay="5000">Longer dwell</div>
```

**Methods:** `swiper.autoplay.start()`, `.stop()`, `.pause()`, `.resume()`

**Events:** `autoplayStart`, `autoplayStop`, `autoplayPause`, `autoplayResume`, `autoplay` (on slide change), `autoplayTimeLeft(swiper, timeLeft, percentage)`

### Pause on Hover Pattern

```js
const swiper = new Swiper('.swiper', {
  autoplay: {
    delay: 3000,
    pauseOnMouseEnter: true,
  },
});
// OR manually:
swiper.el.addEventListener('mouseenter', () => swiper.autoplay?.pause());
swiper.el.addEventListener('mouseleave', () => swiper.autoplay?.resume());
```

## Pagination Indicators

### Bullets (Default)

```js
new Swiper('.swiper', {
  pagination: {
    el: '.swiper-pagination',
    type: 'bullets',
    clickable: true,           // Click to navigate
    dynamicBullets: false,     // Show limited bullets for many slides
    dynamicMainBullets: 1,     // Number of main bullets visible
    renderBullet: (index, className) =>
      `<span class="${className}">${index + 1}</span>`,
    bulletClass: 'swiper-pagination-bullet',
    bulletActiveClass: 'swiper-pagination-bullet-active',
    lockClass: 'swiper-pagination-lock',
    hiddenClass: 'swiper-pagination-hidden',
    clickableClass: 'swiper-pagination-clickable',
  },
});
```

### Fraction (e.g. "01 / 05")

```js
pagination: {
  type: 'fraction',
  formatFractionCurrent: (num) => String(num).padStart(2, '0'),
  formatFractionTotal: (num) => String(num).padStart(2, '0'),
  renderFraction: (currentClass, totalClass) =>
    `<span class="${currentClass}"></span> / <span class="${totalClass}"></span>`,
}
```

### Progress Bar

```js
pagination: {
  type: 'progressbar',
  progressbarOpposite: false,  // Cross-direction progress bar
  renderProgressbar: (fillClass) => `<span class="${fillClass}"></span>`,
}
```

### Custom

```js
pagination: {
  type: 'custom',
  renderCustom: (swiper, current, total) =>
    `<span>${current} of ${total}</span>`,
}
```

## Navigation Arrows

```js
const swiper = new Swiper('.swiper', {
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
    addIcons: true,          // Adds SVG arrow icons automatically
    hideOnClick: false,      // Hide buttons after click on container
    disabledClass: 'swiper-button-disabled',
    hiddenClass: 'swiper-button-hidden',
    lockClass: 'swiper-button-lock',
  },
});
```

### Custom Navigation Elements Outside Container

```jsx
function CustomNav() {
  const swiperRef = useRef<SwiperClass>(null);

  return (
    <div>
      <Swiper ref={swiperRef} navigation={false}>
        {/* slides */}
      </Swiper>
      <button onClick={() => swiperRef.current?.slidePrev()}>Previous</button>
      <button onClick={() => swiperRef.current?.slideNext()}>Next</button>
    </div>
  );
}
```

**Events:** `navigationPrev`, `navigationNext`, `navigationShow`, `navigationHide`

## Scrollbar

```js
new Swiper('.swiper', {
  scrollbar: {
    el: '.swiper-scrollbar',
    hide: true,           // Auto-hide after interaction
    draggable: true,      // User can drag scrollbar thumb
    snapOnRelease: true,  // Snap to slide on release
    dragSize: 'auto',     // 'auto' or number in px
    lockClass: 'swiper-scrollbar-lock',
    dragClass: 'swiper-scrollbar-drag',
  },
});
```

**Events:** `scrollbarDragStart`, `scrollbarDragMove`, `scrollbarDragEnd`

## Transition Effects

### Slide (Default)

Standard horizontal/vertical sliding. No module needed.

```js
{ effect: 'slide', speed: 300 }
```

### Fade

```js
import { EffectFade } from 'swiper/modules';
import 'swiper/css/effect-fade';

const swiper = new Swiper('.swiper', {
  modules: [EffectFade],
  effect: 'fade',
  fadeEffect: { crossFade: false },
});
```

When `crossFade: false` (default), slides fade in/out sequentially. When `true`, slides fade over each other simultaneously.

### Coverflow (3D)

```js
import { EffectCoverflow } from 'swiper/modules';
import 'swiper/css/effect-coverflow';

const swiper = new Swiper('.swiper', {
  modules: [EffectCoverflow],
  effect: 'coverflow',
  coverflowEffect: {
    rotate: 50,       // Rotation angle (degrees)
    stretch: 0,       // Space between slides (px or "50%")
    depth: 100,       // Z-axis offset (px)
    scale: 1,         // Side slide scale
    modifier: 1,      // Effect intensity multiplier
    slideShadows: true,
  },
  centeredSlides: true,
  slidesPerView: 'auto',
});
```

### Cube (3D)

```js
import { EffectCube } from 'swiper/modules';
import 'swiper/css/effect-cube';

const swiper = new Swiper('.swiper', {
  modules: [EffectCube],
  effect: 'cube',
  cubeEffect: {
    slideShadows: true,
    shadow: true,         // Main shadow behind cube
    shadowOffset: 20,     // Shadow offset (px)
    shadowScale: 0.94,    // Shadow scale
  },
});
```

### Flip (3D)

```js
import { EffectFlip } from 'swiper/modules';
import 'swiper/css/effect-flip';

const swiper = new Swiper('.swiper', {
  modules: [EffectFlip],
  effect: 'flip',
  flipEffect: {
    slideShadows: true,
    limitRotation: true,  // Prevent rotation beyond perpendicular
  },
});
```

### Cards

```js
import { EffectCards } from 'swiper/modules';
import 'swiper/css/effect-cards';

const swiper = new Swiper('.swiper', {
  modules: [EffectCards],
  effect: 'cards',
  cardsEffect: {
    slideShadows: true,
    rotate: true,          // Enable card rotation
    perSlideRotate: 2,     // Degrees per slide
    perSlideOffset: 8,     // Offset px per slide
  },
});
```

### Creative (Custom Transforms)

The most flexible effect — define previous/next slide transforms directly.

```js
import { EffectCreative } from 'swiper/modules';
import 'swiper/css/effect-creative';

const swiper = new Swiper('.swiper', {
  modules: [EffectCreative],
  effect: 'creative',
  creativeEffect: {
    prev: {
      translate: ['-120%', 0, -500],  // [X, Y, Z]
      rotate: [0, 0, 15],              // [X, Y, Z] degrees
      opacity: 0,
      scale: 1,
      shadow: true,
      origin: 'left center',
    },
    next: {
      translate: ['120%', 0, -500],
      rotate: [0, 0, -15],
      opacity: 0,
      scale: 1,
      shadow: true,
      origin: 'right center',
    },
    limitProgress: 2,          // How many adjacent slides get transforms
    shadowPerProgress: false,   // Distribute shadow opacity
    progressMultiplier: 1,      // Multiply transforms
    perspective: true,          // Enable 3D perspective
  },
});
```

## Zoom Interaction

```js
import { Zoom } from 'swiper/modules';
import 'swiper/css/zoom';

const swiper = new Swiper('.swiper', {
  modules: [Zoom],
  zoom: {
    maxRatio: 3,                   // Max zoom level
    minRatio: 1,                   // Min zoom level
    toggle: true,                  // Enable double-tap toggle
    panOnMouseMove: false,         // Pan when mouse moves over zoomed image
    limitToOriginalSize: false,    // Cap max zoom at image native size
  },
});

// Methods
swiper.zoom.in(2);     // Zoom in (optional ratio)
swiper.zoom.out();     // Zoom out
swiper.zoom.toggle();  // Toggle zoom state
```

**HTML structure for zoom:**
```html
<div class="swiper-slide">
  <div class="swiper-zoom-container">
    <img src="image.jpg" />
  </div>
</div>
```

## RTL (Right-to-Left) Support

```js
const swiper = new Swiper('.swiper', {
  direction: 'horizontal',
});

// Change language direction dynamically
swiper.changeLanguageDirection('rtl');  // or 'ltr'
```

Swiper is the only carousel library with 100% RTL support out of the box. Set `dir="rtl"` on the HTML element or use the API method.

## Hash Navigation

```js
import { HashNavigation } from 'swiper/modules';

const swiper = new Swiper('.swiper', {
  modules: [HashNavigation],
  hashNavigation: {
    watchState: true,  // Track URL hash changes
  },
});
```

Navigating to `#slide2` in URL will move Swiper to slide index 2.

## History Navigation

```js
import { History } from 'swiper/modules';

const swiper = new Swiper('.swiper', {
  modules: [History],
  history: {
    key: 'slides',       // URL key (results in ?slides=2)
    replaceState: false, // Use replaceState instead of pushState
  },
});
```

## Touch Event Targets

```js
const swiper = new Swiper('.swiper', {
  touchEventsTarget: 'wrapper',  // 'container' or 'wrapper'
});
```

- `'container'` — Touch events bound to entire Swiper container
- `'wrapper'` — Touch events bound only to slides wrapper

## Nesting Swipers

```jsx
<div>
  {/* Outer horizontal */}
  <Swiper direction="horizontal">
    <SwiperSlide>
      {/* Inner vertical — needs `nested: true` because same direction as parent */}
      <Swiper direction="horizontal" nested>
        <SwiperSlide>...</SwiperSlide>
      </Swiper>
    </SwiperSlide>
  </Swiper>
</div>
```

Use `nested: true` when inner Swiper shares the same direction as its parent. Cross-direction (e.g., horizontal inside vertical) doesn't need it.
