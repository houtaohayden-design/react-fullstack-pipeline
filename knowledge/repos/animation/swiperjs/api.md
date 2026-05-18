# Swiper.js API Reference

> Most modern mobile touch slider with hardware accelerated transitions. v12.1.4  
> Source: https://github.com/nolimits4web/swiper | 40k+ stars

## Setup

```bash
npm install swiper
```

```js
// Import Swiper + styles
import Swiper from 'swiper';
import 'swiper/css';

// Import modules (tree-shakeable)
import { Navigation, Pagination, Autoplay } from 'swiper/modules';

const swiper = new Swiper('.swiper', {
  modules: [Navigation, Pagination, Autoplay],
  // options...
});
```

Package is tree-shakeable. Only imported modules end up in your bundle. CSS is imported separately from `swiper/css`.

## React Integration

```tsx
import { Swiper, SwiperSlide } from 'swiper/react';
import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/pagination';

export default function MyCarousel() {
  return (
    <Swiper
      spaceBetween={50}
      slidesPerView={3}
      navigation
      pagination={{ clickable: true }}
      onSlideChange={() => console.log('slide change')}
      onSwiper={(swiper) => console.log(swiper)}
    >
      <SwiperSlide>Slide 1</SwiperSlide>
      <SwiperSlide>Slide 2</SwiperSlide>
      <SwiperSlide>Slide 3</SwiperSlide>
    </Swiper>
  );
}
```

### React Component API

**`<Swiper>`** - Accepts all SwiperOptions as props +:
- `tag` (string, default `'div'`) — Container tag
- `wrapperTag` (string, default `'div'`) — Wrapper tag
- `onSwiper` (callback) — Receives Swiper instance on mount
- `className` — Additional CSS classes
- All event callbacks: `onSlideChange`, `onSlideChangeTransitionStart`, `onSlideChangeTransitionEnd`, `onTouchStart`, `onTouchEnd`, `onTransitionStart`, `onTransitionEnd`, `onProgress`, `onReachBeginning`, `onReachEnd`, etc.

**`<SwiperSlide>`** accepts:
- `tag` (string, default `'div'`) — Slide tag
- `zoom` (boolean) — Enable zoom wrapper for this slide
- `lazy` (boolean) — Add lazy preloader
- `virtualIndex` (number) — Index for virtual slides
- `children` — `ReactNode | ((slideData: SlideData) => ReactNode)`

**Hooks:**
- `useSwiper()` — Get Swiper instance from any child component
- `useSwiperSlide()` — Get slide state: `{ isActive, isVisible, isFullyVisible, isPrev, isNext }`

## Constructor

```js
new Swiper(container: CSSSelector | HTMLElement, options?: SwiperOptions)
```

Static methods:
- `Swiper.use([Module1, Module2])` — Install modules at runtime
- `Swiper.extendDefaults(options)` — Extend global defaults

## Core Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `init` | boolean | `true` | Auto-initialize on creation |
| `direction` | `'horizontal' \| 'vertical'` | `'horizontal'` | Sliding direction |
| `speed` | number | `300` | Transition duration (ms) |
| `initialSlide` | number | `0` | Index of initial slide |
| `loop` | boolean | `false` | Enable infinite loop mode |
| `rewind` | boolean | `false` | Rewind to first/last slide (no duplicates needed) |
| `effect` | string | `'slide'` | Transition effect: `'slide'`, `'fade'`, `'cube'`, `'coverflow'`, `'flip'`, `'creative'`, `'cards'` |
| `cssMode` | boolean | `false` | Use native CSS scroll-snap (better performance, modern browsers) |
| `enabled` | boolean | `true` | Enable/disable Swiper |
| `autoHeight` | boolean | `false` | Adaptive height to current slide |
| `slidesPerView` | number \| `'auto'` | `1` | Slides visible at once |
| `slidesPerGroup` | number | `1` | Slides to slide per transition |
| `spaceBetween` | number | `0` | Gap between slides (px) |
| `centeredSlides` | boolean | `false` | Active slide centered |
| `centeredSlidesBounds` | boolean | `false` | Centered slides with edge bounds |
| `slidesOffsetBefore` | number | `0` | Offset before first slide (px) |
| `slidesOffsetAfter` | number | `0` | Offset after last slide (px) |
| `grabCursor` | boolean | `false` | Show grab cursor on hover |
| `watchSlidesProgress` | boolean | `false` | Watch slide visibility progress |
| `watchOverflow` | boolean | `true` | Disable swiper when slides < slidesPerView |
| `breakpoints` | object | `undefined` | Responsive breakpoints (see patterns.md) |
| `breakpointsBase` | `'window' \| 'container'` | `'window'` | Breakpoint reference |
| `width` | number \| null | `null` | Force width (px) — disables responsiveness |
| `height` | number \| null | `null` | Force height (px) |
| `preventClicks` | boolean | `true` | Prevent accidental clicks while swiping |
| `slideToClickedSlide` | boolean | `false` | Click slide to navigate to it |
| `updateOnWindowResize` | boolean | `true` | Recalc on window resize |
| `resizeObserver` | boolean | `true` | Use ResizeObserver for container size |
| `nested` | boolean | `false` | For nested Swipers using same direction |
| `virtualTranslate` | boolean | `false` | Don't move wrapper (custom transitions) |
| `createElements` | boolean | `false` | Auto-create wrapper, navigation, pagination nodes |
| `noSwiping` | boolean | `true` | Disable swipe on elements with noSwipingClass |
| `noSwipingClass` | string | `'swiper-no-swiping'` | Class to disable swiping on |
| `noSwipingSelector` | string \| null | `null` | Selector for no-swipe elements |

## Touch / Drag Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `touchRatio` | number | `1` | Touch distance to slide distance ratio |
| `touchAngle` | number | `45` | Allowed swipe angle (deg) |
| `simulateTouch` | boolean | `true` | Use mouse events to simulate touch |
| `shortSwipes` | boolean | `true` | Enable short swipes |
| `longSwipes` | boolean | `true` | Enable long swipes |
| `longSwipesRatio` | number | `0.5` | Ratio of slide width to trigger long swipe |
| `longSwipesMs` | number | `300` | Minimum duration for long swipe (ms) |
| `followFinger` | boolean | `true` | Slide follows finger/pointer |
| `allowTouchMove` | boolean | `true` | Allow touch/swipe interactions |
| `threshold` | number | `5` | Minimum distance to initiate swipe (px) |
| `resistans` | boolean | `true` | Resistance at edges |
| `resistanceRatio` | number | `0.85` | Resistance multiplier at edge |
| `preventInteractionOnTransition` | boolean | `false` | Block interaction during transitions |
| `edgeSwipeDetection` | boolean | `false` | Detect swipe from screen edge |
| `edgeSwipeThreshold` | number | `20` | Edge detection threshold (px) |

## Module System (Tree-Shakeable)

Import modules from `swiper/modules`. Pass them to the `modules` array option:

```js
import Swiper from 'swiper';
import { Navigation, Pagination, Autoplay } from 'swiper/modules';

const swiper = new Swiper('.swiper', {
  modules: [Navigation, Pagination, Autoplay],
  navigation: { ... },
  pagination: { ... },
  autoplay: { ... },
});
```

### Available Modules

| Module | Import | Key Options | Description |
|--------|--------|-------------|-------------|
| **Navigation** | `Navigation` | `nextEl`, `prevEl`, `hideOnClick`, `disabledClass`, `hiddenClass` | Prev/next arrow buttons |
| **Pagination** | `Pagination` | `el`, `type` (`'bullets'/'fraction'/'progressbar'/'custom'`), `clickable`, `dynamicBullets`, `renderBullet`, `renderFraction`, `renderCustom` | Pagination indicators |
| **Autoplay** | `Autoplay` | `delay` (3000), `stopOnLastSlide`, `disableOnInteraction`, `reverseDirection`, `pauseOnMouseEnter` | Auto-advance slides |
| **EffectFade** | `EffectFade` | `crossFade` | Fade transition |
| **EffectCoverflow** | `EffectCoverflow` | `rotate` (50), `stretch`, `depth` (100), `scale` (1), `slideShadows`, `modifier` | 3D Coverflow effect |
| **EffectCube** | `EffectCube` | `slideShadows`, `shadow`, `shadowOffset` (20), `shadowScale` (0.94) | 3D Cube rotation |
| **EffectFlip** | `EffectFlip` | `slideShadows`, `limitRotation` | 3D Flip effect |
| **EffectCards** | `EffectCards` | `slideShadows`, `rotate`, `perSlideRotate` (2), `perSlideOffset` (8) | Card stack effect |
| **EffectCreative** | `EffectCreative` | `prev` (transform), `next` (transform), `limitProgress`, `shadowPerProgress`, `progressMultiplier`, `perspective` | Custom transform transitions |
| **Thumbs** | `Thumbs` | `swiper` (other Swiper instance), `slideThumbActiveClass`, `multipleActiveThumbs`, `autoScrollOffset` | Thumbnail gallery control |
| **Zoom** | `Zoom` | `maxRatio` (3), `minRatio` (1), `toggle`, `panOnMouseMove`, `limitToOriginalSize` | Pinch-to-zoom on slides |
| **Scrollbar** | `Scrollbar` | `el`, `hide`, `draggable`, `snapOnRelease`, `dragSize` | Custom scrollbar |
| **Keyboard** | `Keyboard` | `enabled`, `onlyInViewport`, `pageUpDown`, `speed` | Arrow/page key navigation |
| **Mousewheel** | `Mousewheel` | `enabled`, `forceToAxis`, `releaseOnEdges`, `invert`, `sensitivity`, `eventsTarget` | Mousewheel scroll control |
| **Virtual** | `Virtual` | `enabled`, `slides` (array), `renderSlide`, `renderExternal`, `cache`, `addSlidesBefore`, `addSlidesAfter` | Virtual rendering for large lists |
| **FreeMode** | `FreeMode` | `enabled`, `momentum`, `momentumRatio`, `momentumVelocityRatio`, `momentumBounce`, `sticky`, `minimumVelocity` | Free-scroll without snapping |
| **Parallax** | `Parallax` | `enabled` | Parallax elements inside slides |
| **Grid** | `Grid` | `rows`, `fill` (`'column'/'row'`) | Multi-row slide grid |
| **A11y** | `A11y` | `enabled`, `prevSlideMessage`, `nextSlideMessage`, etc. | ARIA accessibility |
| **HashNavigation** | `HashNavigation` | `enabled`, `watchState` | URL hash-based navigation |
| **History** | `History` | `enabled`, `key`, `replaceState` | URL history integration |
| **Controller** | `Controller` | `control`, `by`, `inverse` | Synchronize multiple Swipers |
| **Manipulation** | `Manipulation` | — | Methods: `appendSlide`, `prependSlide`, `addSlide`, `removeSlide`, `removeAllSlides` |

## Instance Methods

```js
swiper.slideNext(speed?: number, runCallbacks?: boolean): boolean
swiper.slidePrev(speed?: number, runCallbacks?: boolean): boolean
swiper.slideTo(index: number, speed?: number, runCallbacks?: boolean): boolean
swiper.slideToLoop(index: number, speed?: number, runCallbacks?: boolean): Swiper
swiper.slideReset(speed?: number, runCallbacks?: boolean): boolean
swiper.slideToClosest(speed?: number, runCallbacks?: boolean): boolean
swiper.slidesPerViewDynamic(): number
swiper.setProgress(progress: number, speed?: number): void
swiper.translateTo(translate: number, speed: number, runCallbacks?: boolean, translateBounds?: boolean): any

swiper.update(): void
swiper.updateSize(): void
swiper.updateSlides(): void
swiper.updateProgress(): void
swiper.updateSlidesClasses(): void
swiper.updateAutoHeight(speed?: number): void

swiper.init(el?: HTMLElement): Swiper
swiper.destroy(deleteInstance?: boolean, cleanStyles?: boolean): void
swiper.disable(): void
swiper.enable(): void

swiper.changeDirection(direction?: 'horizontal' | 'vertical', needUpdate?: boolean): void
swiper.changeLanguageDirection(direction: 'rtl' | 'ltr'): void

swiper.getTranslate(): any
swiper.setTranslate(translate: any): void
swiper.minTranslate(): number
swiper.maxTranslate(): number

swiper.setGrabCursor(): void
swiper.unsetGrabCursor(): void

swiper.detachEvents(): void
swiper.attachEvents(): void

// Loop internal
swiper.loopCreate(): void
swiper.loopDestroy(): void
```

## Instance Properties

| Property | Type | Description |
|----------|------|-------------|
| `params` | `SwiperOptions` | Active parameters (after breakpoint merge) |
| `originalParams` | `SwiperOptions` | Original initialization parameters |
| `el` | `HTMLElement` | Container element |
| `wrapperEl` | `HTMLElement` | Wrapper element |
| `slidesEl` | `HTMLElement` | Slides container |
| `slides` | `HTMLElement[]` | Array of slide elements |
| `width` | number | Container width |
| `height` | number | Container height |
| `translate` | number | Current wrapper translate value |
| `progress` | number | Overall progress (0 to 1) |
| `activeIndex` | number | Current active slide index |
| `realIndex` | number | Real index (accounting for loop) |
| `previousIndex` | number | Previously active index |
| `isBeginning` | boolean | At first position |
| `isEnd` | boolean | At last position |
| `isLocked` | boolean | Locked by watchOverflow |
| `animating` | boolean | Currently in transition |
| `enabled` | boolean | Swiper enabled state |
| `touches` | object | `{ startX, startY, currentX, currentY, diff }` |
| `swipeDirection` | `'prev' \| 'next'` | Current swipe direction |
| `allowSlideNext` | boolean | Can slide next |
| `allowSlidePrev` | boolean | Can slide prev |
| `allowTouchMove` | boolean | Can touch move |

### Module Instance Properties

- `swiper.navigation` — `{ nextEl, prevEl, update(), init(), destroy() }`
- `swiper.pagination` — `{ el, bullets[], render(), update(), init(), destroy() }`
- `swiper.autoplay` — `{ running, paused, timeLeft, pause(), resume(), start(), stop() }`
- `swiper.zoom` — `{ enabled, scale, enable(), disable(), in(ratio?), out(), toggle() }`
- `swiper.keyboard` — `{ enabled, enable(), disable() }`
- `swiper.mousewheel` — `{ enabled, enable(), disable() }`
- `swiper.scrollbar` — `{ el, dragEl, updateSize(), setTranslate(), init(), destroy() }`
- `swiper.thumbs` — `{ swiper, update(), init() }`
- `swiper.virtual` — `{ cache, from, to, slides[], appendSlide(), prependSlide(), removeSlide(), removeAllSlides(), update() }`
- `swiper.freeMode` — `{ onTouchMove(), onTouchEnd() }`

## Event System

```js
swiper.on('slideChange', (swiper) => { /* ... * / });
swiper.once('init', (swiper) => { /* ... * / });
swiper.off('slideChange');
swiper.off('slideChange', handlerFunction);
swiper.emit('slideChange');
swiper.onAny((eventName, ...args) => { /* ... * / });
swiper.offAny(handler);
```

Or via options `on` object:
```js
new Swiper('.swiper', {
  on: {
    init: (swiper) => {},
    slideChange: (swiper) => {},
  },
});
```

### Core Events

| Event | Arguments | Description |
|-------|-----------|-------------|
| `init` | swiper | After initialization |
| `afterInit` | swiper | Right after init |
| `beforeInit` | swiper | Right before init |
| `beforeDestroy` | swiper | Before teardown |
| `destroy` | swiper | On destroy |
| `slideChange` | swiper | After active slide changes |
| `slideChangeTransitionStart` | swiper | Animation start to another slide |
| `slideChangeTransitionEnd` | swiper | Animation end to another slide |
| `slideNextTransitionStart` | swiper | Forward animation start |
| `slideNextTransitionEnd` | swiper | Forward animation end |
| `slidePrevTransitionStart` | swiper | Backward animation start |
| `slidePrevTransitionEnd` | swiper | Backward animation end |
| `transitionStart` | swiper | Any transition begins |
| `transitionEnd` | swiper | Any transition ends |
| `beforeTransitionStart` | swiper, speed, internal | Before transition start |
| `beforeSlideChangeStart` | swiper | Before slide change transition |
| `touchStart` | swiper, event | Touch/press on Swiper |
| `touchMove` | swiper, event | Touch move over Swiper |
| `touchMoveOpposite` | swiper, event | Touch move opposite to direction |
| `sliderMove` | swiper, event | Touch move and translate |
| `sliderFirstMove` | swiper, event | First touch/drag move |
| `touchEnd` | swiper, event | Touch release |
| `click` | swiper, event | Click/tap on Swiper |
| `tap` | swiper, event | Tap on Swiper |
| `doubleTap` | swiper, event | Double tap |
| `doubleClick` | swiper, event | Double click |
| `progress` | swiper, progress (number) | Progress changed (0-1) |
| `reachBeginning` | swiper | Reached first slide |
| `reachEnd` | swiper | Reached last slide |
| `toEdge` | swiper | Went to beginning or end |
| `fromEdge` | swiper | Left beginning or end |
| `setTranslate` | swiper, translate (number) | Wrapper position changes |
| `setTransition` | swiper, transition (number) | Animation starts |
| `resize` | swiper | Window resize before handler |
| `beforeResize` | swiper | Before resize handler |
| `observerUpdate` | swiper | DOM mutation observed |
| `beforeLoopFix` | swiper | Before loop correction |
| `loopFix` | swiper | After loop correction |
| `breakpoint` | swiper, breakpointParams | Breakpoint changed |
| `activeIndexChange` | swiper | Active index changed |
| `snapIndexChange` | swiper | Snap index changed |
| `realIndexChange` | swiper | Real index changed |
| `changeDirection` | swiper | Direction changed |
| `momentumBounce` | swiper | Momentum bounce |
| `orientationchange` | swiper | Orientation change |
| `slidesLengthChange` | swiper | Number of slides changed |
| `slidesGridLengthChange` | swiper | Slides grid changed |
| `snapGridLengthChange` | swiper | Snap grid changed |
| `update` | swiper | After swiper.update() |
| `lock` | swiper | Locked (watchOverflow) |
| `unlock` | swiper | Unlocked (watchOverflow) |

### Module Events

| Event | Module | Description |
|-------|--------|-------------|
| `autoplayStart` | Autoplay | Autoplay started |
| `autoplayStop` | Autoplay | Autoplay stopped |
| `autoplayPause` | Autoplay | Autoplay paused |
| `autoplayResume` | Autoplay | Autoplay resumed |
| `autoplayTimeLeft` | Autoplay | Time left update (ms, percentage) |
| `autoplay` | Autoplay | Slide changed by autoplay |
| `navigationHide` | Navigation | Navigation hidden |
| `navigationShow` | Navigation | Navigation shown |
| `navigationPrev` | Navigation | Prev button clicked |
| `navigationNext` | Navigation | Next button clicked |
| `paginationRender` | Pagination | Pagination rendered |
| `paginationUpdate` | Pagination | Pagination updated |
| `paginationHide` | Pagination | Pagination hidden |
| `paginationShow` | Pagination | Pagination shown |
| `scrollbarDragStart` | Scrollbar | Scrollbar drag start |
| `scrollbarDragMove` | Scrollbar | Scrollbar drag move |
| `scrollbarDragEnd` | Scrollbar | Scrollbar drag end |
| `zoomChange` | Zoom | Zoom scale changed |
| `keyPress` | Keyboard | Key pressed |
| `scroll` | Mousewheel | Mousewheel scrolled |
