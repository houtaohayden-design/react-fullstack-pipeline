# Swiper.js Common Patterns

> Production-tested carousel/slider patterns using Swiper.js  
> Used by DJI, Apple, and 40k+ starred repositories

## Hero Carousel

Full-width hero section with autoplay, fade or slide effect, and pagination.

```tsx
import { Swiper, SwiperSlide } from 'swiper/react';
import { Autoplay, EffectFade, Pagination } from 'swiper/modules';
import 'swiper/css/effect-fade';
import 'swiper/css/pagination';

function HeroCarousel() {
  return (
    <Swiper
      modules={[Autoplay, EffectFade, Pagination]}
      effect="fade"
      autoplay={{ delay: 5000, disableOnInteraction: false }}
      pagination={{ clickable: true }}
      loop
      speed={800}
      className="h-screen w-full"
    >
      <SwiperSlide>
        <div className="flex h-full items-center justify-center bg-neutral-900">
          <h1 className="text-6xl font-bold text-white">Slide 1</h1>
        </div>
      </SwiperSlide>
      <SwiperSlide>
        <div className="flex h-full items-center justify-center bg-blue-600">
          <h1 className="text-6xl font-bold text-white">Slide 2</h1>
        </div>
      </SwiperSlide>
    </Swiper>
  );
}
```

**Key options:** `effect="fade"`, `loop`, `autoplay`, `speed`, `disableOnInteraction: false`

## Product Gallery with Thumbnails

Synchronized main slider + thumbnail strip. DJI-style product showcase.

```tsx
import { useState } from 'react';
import { Swiper, SwiperSlide } from 'swiper/react';
import { Thumbs, Navigation, Zoom } from 'swiper/modules';
import type { Swiper as SwiperClass } from 'swiper';

function ProductGallery({ images }: { images: string[] }) {
  const [thumbsSwiper, setThumbsSwiper] = useState<SwiperClass | null>(null);

  return (
    <div className="space-y-4">
      {/* Main Gallery */}
      <Swiper
        modules={[Thumbs, Navigation, Zoom]}
        thumbs={{ swiper: thumbsSwiper }}
        zoom={{ maxRatio: 3 }}
        navigation
        spaceBetween={10}
        className="aspect-square rounded-xl overflow-hidden"
      >
        {images.map((src, i) => (
          <SwiperSlide key={i}>
            <div className="swiper-zoom-container">
              <img src={src} alt={`Product ${i + 1}`} className="w-full h-full object-cover" />
            </div>
          </SwiperSlide>
        ))}
      </Swiper>

      {/* Thumbnail Strip */}
      <Swiper
        onSwiper={setThumbsSwiper}
        modules={[Thumbs]}
        spaceBetween={10}
        slidesPerView={4}
        watchSlidesProgress
        className="h-20"
      >
        {images.map((src, i) => (
          <SwiperSlide key={i} className="cursor-pointer rounded-lg overflow-hidden opacity-60 transition-opacity">
            <img src={src} alt={`Thumb ${i + 1}`} className="w-full h-full object-cover" />
          </SwiperSlide>
        ))}
      </Swiper>
    </div>
  );
}
```

**Key pattern:** Two Swiper instances linked via `thumbs={{ swiper: thumbsSwiper }}`. Thumb strip uses `watchSlidesProgress` for active state tracking via `.swiper-slide-thumb-active` class.

## Card Carousel (Centered Cards)

Spotlight/featured card pattern with centered active slide and side previews.

```tsx
import { Swiper, SwiperSlide } from 'swiper/react';
import { Pagination } from 'swiper/modules';

function CardCarousel({ cards }: { cards: Card[] }) {
  return (
    <Swiper
      modules={[Pagination]}
      slidesPerView="auto"
      centeredSlides
      spaceBetween={24}
      pagination={{ clickable: true }}
      className="py-8"
    >
      {cards.map((card, i) => (
        <SwiperSlide key={i} className="max-w-sm">
          <div className="rounded-2xl bg-white p-6 shadow-xl transition-transform duration-300">
            <img src={card.image} alt={card.title} className="rounded-xl mb-4" />
            <h3 className="text-xl font-bold">{card.title}</h3>
            <p className="text-neutral-500">{card.description}</p>
          </div>
        </SwiperSlide>
      ))}
    </Swiper>
  );
}
```

**Key options:** `slidesPerView="auto"`, `centeredSlides`, `spaceBetween`. Each slide has `max-w-sm` for sizing.

## Infinite Loop Carousel

Continuous auto-scrolling carousel for logos, testimonials, or data streams.

```tsx
import { Swiper, SwiperSlide } from 'swiper/react';
import { Autoplay, FreeMode } from 'swiper/modules';
import 'swiper/css/free-mode';

function InfiniteLoopCarousel() {
  return (
    <Swiper
      modules={[Autoplay, FreeMode]}
      slidesPerView="auto"
      spaceBetween={30}
      speed={5000}
      autoplay={{
        delay: 0,
        disableOnInteraction: false,
      }}
      freeMode={{ enabled: true, momentum: false }}
      loop
      allowTouchMove={false}
    >
      {logos.map((logo, i) => (
        <SwiperSlide key={i} className="!w-auto">
          <img src={logo} alt="Partner" className="h-10 w-auto opacity-40 hover:opacity-100 transition-opacity" />
        </SwiperSlide>
      ))}
    </Swiper>
  );
}
```

**Key options:** `speed: 5000`, `autoplay.delay: 0` (continuous), `freeMode` (no snap), `allowTouchMove: false`, `loop`.

## Responsive Breakpoints

Adapt slides per view, spacing, and even pagination/navigation at different screen sizes.

```tsx
function ResponsiveGrid({ items }: { items: Item[] }) {
  return (
    <Swiper
      spaceBetween={16}
      slidesPerView={1.2}
      breakpoints={{
        // Mobile (>= 640px)
        640: { slidesPerView: 1.5, spaceBetween: 16 },
        // Tablet (>= 768px)
        768: { slidesPerView: 2.5, spaceBetween: 20 },
        // Desktop (>= 1024px)
        1024: { slidesPerView: 3.5, spaceBetween: 24 },
        // Large Desktop (>= 1280px)
        1280: { slidesPerView: 4.5, spaceBetween: 32 },
      }}
      navigation
      pagination={{ clickable: true }}
    >
      {items.map((item, i) => (
        <SwiperSlide key={i}>
          <ItemCard item={item} />
        </SwiperSlide>
      ))}
    </Swiper>
  );
}
```

**Key options:** `slidesPerView` supports fractional values for peek-a-boo effect (`.2`, `.5`). `breakpoints` matches Tailwind breakpoints. You can also change direction, enable/disable modules, or swap effect per breakpoint.

## Lazy Loading

```tsx
import { Swiper, SwiperSlide } from 'swiper/react';
import { Lazy } from 'swiper/modules';

function LazyGallery() {
  return (
    <Swiper modules={[Lazy]} lazy={{ loadPrevNext: true }} preloadImages={false}>
      {images.map((src, i) => (
        <SwiperSlide key={i}>
          <img data-src={src} className="swiper-lazy" />
          <div className="swiper-lazy-preloader" />
        </SwiperSlide>
      ))}
    </Swiper>
  );
}
```

**Key options:** `preloadImages: false`, `lazy.loadPrevNext: true` preloads adjacent slides. Images need `data-src` + `swiper-lazy` class. Built-in CSS spinner available via `.swiper-lazy-preloader`.

## Parallax Carousel

Elements within slides move at different speeds during swipe.

```html
<div class="swiper" data-swiper-parallax="-100%">
  <div class="swiper-wrapper">
    <div class="swiper-slide">
      <div data-swiper-parallax="-200">Slow element</div>
      <div data-swiper-parallax="-500">Faster element</div>
      <div data-swiper-parallax-opacity="0">Opacity fades in</div>
      <div data-swiper-parallax-scale="0.8">Scale effect</div>
    </div>
  </div>
</div>
```

```js
const swiper = new Swiper('.swiper', {
  modules: [Parallax],
  parallax: { enabled: true },
  speed: 600,
});
```

**Parallax attributes:**
- `data-swiper-parallax` — Translate offset (negative = slower)
- `data-swiper-parallax-x`, `-y` — Axis-specific
- `data-swiper-parallax-opacity` — Target opacity
- `data-swiper-parallax-scale` — Scale target
- `data-swiper-parallax-duration` — Custom duration (ms)
- Percentage values use `%`, numbers use `px`

## Vertical Slider

```tsx
function VerticalSlider() {
  return (
    <Swiper
      direction="vertical"
      slidesPerView={1}
      spaceBetween={0}
      mousewheel
      pagination={{ clickable: true }}
      className="h-screen"
    >
      <SwiperSlide>Section 1</SwiperSlide>
      <SwiperSlide>Section 2</SwiperSlide>
    </Swiper>
  );
}
```

**Key options:** `direction="vertical"`, `mousewheel` for scroll-like behavior, `className="h-screen"` for full-viewport sections.

## Multi-Row Grid Configuration

```tsx
function GridLayout() {
  return (
    <Swiper
      modules={[Grid]}
      grid={{ rows: 2, fill: 'row' }}
      spaceBetween={16}
      slidesPerView={3}
      pagination={{ clickable: true }}
    >
      {items.map((item, i) => (
        <SwiperSlide key={i}><ItemCard item={item} /></SwiperSlide>
      ))}
    </Swiper>
  );
}
```

**Key options:** `grid.rows`, `grid.fill` (`'row'` fills row-first, `'column'` fills column-first). Combine with `slidesPerView` for grids.

## Controller (Synchronized Sliders)

```tsx
function SyncedSliders() {
  const [controller, setController] = useState<SwiperClass | null>(null);

  return (
    <>
      <Swiper modules={[Controller]} controller={{ control: controller }} onSwiper={setController}>
        {/* Primary slides */}
      </Swiper>
      {/* This slider follows the primary one */}
      <Swiper modules={[Controller]} controller={{ control: controller, by: 'container' }}>
        {/* Secondary slides */}
      </Swiper>
    </>
  );
}
```

**Key options:** `controller.control` (Swiper instance), `controller.by` (`'slide'` or `'container'`), `controller.inverse` (reverse direction).

## Virtual Slides (Large Lists)

```tsx
function VirtualCarousel() {
  return (
    <Swiper
      modules={[Virtual]}
      virtual={{ slides: thousandsOfItems, renderSlide: (item, index) => (
        `<div class="swiper-slide">${item.content}</div>`
      )}}
      slidesPerView={3}
      spaceBetween={16}
    />
  );
}

// React: just map children, Swiper handles virtual internally
function ReactVirtual({ items }) {
  return (
    <Swiper modules={[Virtual]} virtual={{ enabled: true }} slidesPerView={3}>
      {items.map((item) => (
        <SwiperSlide key={item.id} virtualIndex={item.id}>{item.content}</SwiperSlide>
      ))}
    </Swiper>
  );
}
```

**Key pattern:** Pass `virtual.enabled: true` and use `virtualIndex` on SwiperSlide. Swiper only renders visible + buffer slides in DOM. Use `addSlidesBefore`/`addSlidesAfter` for preload buffer.

## Dynamic Content Update

```tsx
function DynamicSlider() {
  const [images, setImages] = useState(initialImages);

  return (
    <Swiper onUpdate={(swiper) => swiper.slideTo(0)} key={images.length}>
      {images.map((img, i) => (
        <SwiperSlide key={img.id}>{/* ... */}</SwiperSlide>
      ))}
    </Swiper>
  );
}
```

**Key pattern:** Change the `key` prop on `<Swiper>` to force reinitialization when slide data changes fundamentally. For adding/removing slides, use `swiper.update()` after DOM changes.

## Dual Direction (Horizontal + Vertical)

```tsx
function MixedDirection() {
  return (
    <Swiper direction="horizontal" className="h-screen">
      <SwiperSlide>
        <Swiper direction="vertical" nested className="h-full">
          <SwiperSlide>Sub 1</SwiperSlide>
          <SwiperSlide>Sub 2</SwiperSlide>
        </Swiper>
      </SwiperSlide>
    </Swiper>
  );
}
```

**Key option:** `nested: true` on the inner Swiper when sharing the same direction as parent. Cross-direction nested swipers don't need it.

## CSS Mode (Native Scroll Snap)

For maximum performance with native browser scroll:

```tsx
function CSSModeCarousel() {
  return (
    <Swiper cssMode slidesPerView="auto" spaceBetween={16}>
      {items.map((item) => (
        <SwiperSlide key={item.id} className="w-80">{/* ... */}</SwiperSlide>
      ))}
    </Swiper>
  );
}
```

**Key option:** `cssMode: true` uses CSS `scroll-snap-type` instead of JS transforms. Limitations: no 3D effects, fewer animation hooks, but better performance and accessibility.
