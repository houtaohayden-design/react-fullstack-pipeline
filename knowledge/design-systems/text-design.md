# Text Design — Kinetic Typography & Advanced Text Effects

Comprehensive text design reference. Animated typography, gradient effects, masking, 3D, glitch, and more. Builds on react-bits text animations (23 components) with additional custom patterns.

---

## 1. Kinetic Typography (Motion Text)

### Pattern A: Character-by-Character Stagger
```tsx
function StaggerChars({ text, className }: { text: string; className?: string }) {
  return (
    <span className={cn('inline-flex', className)}>
      {text.split('').map((char, i) => (
        <motion.span
          key={i}
          initial={{ opacity: 0, y: 20, rotateX: -90 }}
          animate={{ opacity: 1, y: 0, rotateX: 0 }}
          transition={{
            delay: i * 0.04,
            type: 'spring',
            stiffness: 200,
            damping: 20,
          }}
          className={char === ' ' ? 'w-[0.3em]' : ''}
        >
          {char}
        </motion.span>
      ))}
    </span>
  );
}
```

### Pattern B: Word-by-Word Reveal
```tsx
function WordReveal({ text, className }: { text: string; className?: string }) {
  const words = text.split(' ');

  return (
    <p className={cn('flex flex-wrap', className)}>
      {words.map((word, i) => (
        <motion.span
          key={i}
          initial={{ opacity: 0, y: '100%' }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: i * 0.08, duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
          className="mr-[0.25em] overflow-hidden"
        >
          <span className="inline-block">{word}</span>
        </motion.span>
      ))}
    </p>
  );
}
```

### Pattern C: Scrolling Marquee (Infinite)
```tsx
function Marquee({ text, speed = 10 }: { text: string; speed?: number }) {
  return (
    <div className="overflow-hidden whitespace-nowrap">
      <motion.div
        animate={{ x: ['0%', '-50%'] }}
        transition={{ duration: speed, repeat: Infinity, ease: 'linear' }}
        className="inline-flex"
      >
        <span className="text-4xl font-black uppercase tracking-tight pr-8">{text}</span>
        <span className="text-4xl font-black uppercase tracking-tight pr-8">{text}</span>
        <span className="text-4xl font-black uppercase tracking-tight pr-8">{text}</span>
        <span className="text-4xl font-black uppercase tracking-tight pr-8">{text}</span>
      </motion.div>
    </div>
  );
}
```

### Pattern D: Variable Font Weight Animation
```tsx
function VariableWeight({ text }: { text: string }) {
  return (
    <motion.h1
      className="text-6xl font-[var(--weight)]"
      style={{ '--weight': 100 } as React.CSSProperties}
      animate={{
        '--weight': [100, 900, 700, 100],
        letterSpacing: ['0.05em', '-0.02em', '-0.01em', '0.05em'],
      } as unknown as TargetAndTransition}
      transition={{ duration: 4, repeat: Infinity, ease: 'easeInOut' }}
    >
      {text}
    </motion.h1>
  );
}
```

### Pattern E: Rotating Words (Loop)
```tsx
function RotatingWords({ words }: { words: string[] }) {
  const [index, setIndex] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setIndex(i => (i + 1) % words.length);
    }, 2500);
    return () => clearInterval(interval);
  }, [words.length]);

  return (
    <span className="inline-flex relative">
      <AnimatePresence mode="wait">
        <motion.span
          key={index}
          initial={{ y: '100%', opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          exit={{ y: '-100%', opacity: 0 }}
          transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] }}
          className="block bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent"
        >
          {words[index]}
        </motion.span>
      </AnimatePresence>
    </span>
  );
}

// Usage:
// <h1>Discover <RotatingWords words={['Healthy', 'Delicious', 'Quick', 'Simple']} /> Recipes</h1>
```

---

## 2. Gradient Text Effects

### Gradient A: Animated Linear Gradient
```css
.gradient-text-linear {
  background: linear-gradient(
    90deg,
    #667eea,
    #764ba2,
    #f093fb,
    #667eea
  );
  background-size: 300% 100%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: gradientFlow 4s ease infinite;
}

@keyframes gradientFlow {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}
```

### Gradient B: Conic/Radial Gradient
```css
.gradient-text-radial {
  background: radial-gradient(circle at center, #ff6b6b, #4ecdc4, #45b7d1);
  background-size: 200% 200%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: radialShift 6s ease-in-out infinite;
}

@keyframes radialShift {
  0%, 100% { background-position: 0% 50%; background-size: 100% 100%; }
  50% { background-position: 100% 50%; background-size: 200% 200%; }
}
```

### Gradient C: Multi-Stop Rainbow
```css
.rainbow-text {
  background: linear-gradient(
    to right,
    #ef5350, #f48fb1, #7e57c2, #2196f3,
    #26c6da, #43a047, #ffee58, #ff7043
  );
  background-size: 400% 100%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: rainbowFlow 8s linear infinite;
}

@keyframes rainbowFlow {
  0% { background-position: 0% 50%; }
  100% { background-position: 400% 50%; }
}
```

### Gradient D: Metallic Gold Shimmer
```css
.gold-text {
  background: linear-gradient(
    135deg,
    #bf953f 0%,
    #fcf6ba 25%,
    #b38728 50%,
    #fbf5b7 75%,
    #aa771c 100%
  );
  background-size: 200% 200%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: goldShimmer 3s ease-in-out infinite;
}

@keyframes goldShimmer {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}
```

### React Component — Animated Gradient Text
```tsx
function GradientText({
  children,
  variant = 'linear',
  className,
}: {
  children: string;
  variant?: 'linear' | 'radial' | 'rainbow' | 'gold';
  className?: string;
}) {
  const variants = {
    linear: 'gradient-text-linear',
    radial: 'gradient-text-radial',
    rainbow: 'rainbow-text',
    gold: 'gold-text',
  };

  return (
    <span className={cn(variants[variant], 'font-bold', className)}>
      {children}
    </span>
  );
}
```

---

## 3. Text Masking

### Image Through Text
```css
.text-image-mask {
  background-image: url('/hero-image.jpg');
  background-size: cover;
  background-position: center;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-size: clamp(4rem, 10vw, 12rem);
  font-weight: 900;
  line-height: 0.9;
}
```

### Video Through Text
```tsx
function VideoTextMask({ src, text }: { src: string; text: string }) {
  const videoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    videoRef.current?.play();
  }, []);

  return (
    <div className="relative">
      <video ref={videoRef} src={src} muted loop playsInline
        className="absolute inset-0 w-full h-full object-cover" />
      <h1
        className="relative text-[15vw] font-black leading-none text-center mix-blend-screen"
        style={{
          background: 'black',
          color: 'white',
          mixBlendMode: 'screen',
        }}
      >
        {text}
      </h1>
    </div>
  );
}
```

### Reveal Text Mask (Animated)
```tsx
function RevealTextMask({ text }: { text: string }) {
  return (
    <h1 className="relative text-6xl font-black">
      <span className="opacity-0">{text}</span>
      <motion.span
        className="absolute inset-0 bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent"
        initial={{ clipPath: 'inset(0 100% 0 0)' }}
        whileInView={{ clipPath: 'inset(0 0% 0 0)' }}
        viewport={{ once: true }}
        transition={{ duration: 1, ease: [0.22, 1, 0.36, 1] }}
      >
        {text}
      </motion.span>
    </h1>
  );
}
```

---

## 4. 3D Text (CSS Only)

### Perspective 3D
```css
.text-3d {
  font-size: 5rem;
  font-weight: 900;
  color: #fff;
  text-shadow:
    1px 1px 0 #ccc,
    2px 2px 0 #bbb,
    3px 3px 0 #aaa,
    4px 4px 0 #999,
    5px 5px 0 #888,
    6px 6px 0 #777,
    7px 7px 0 #666,
    8px 8px 8px rgba(0, 0, 0, 0.2);
  transform: perspective(500px) rotateY(-5deg) rotateX(2deg);
  transition: transform 0.3s;
}
.text-3d:hover {
  transform: perspective(500px) rotateY(5deg) rotateX(-2deg);
}
```

### Layered Extrusion (Multi-Layer Shadow)
```css
.text-extruded {
  font-size: 6rem;
  font-weight: 900;
  color: #ff6b6b;
  -webkit-text-stroke: 2px #c0392b;
  text-shadow:
    0 1px 0 #c0392b,
    0 2px 0 #c0392b,
    0 3px 0 #c0392b,
    0 4px 0 #c0392b,
    0 5px 0 #c0392b,
    0 6px 0 #c0392b,
    0 10px 20px rgba(0, 0, 0, 0.15);
  letter-spacing: -0.02em;
}
```

### Floating 3D (CSS Transform)
```tsx
function Floating3DText({ text }: { text: string }) {
  return (
    <div className="perspective-1000">
      <motion.h1
        className="text-6xl font-black"
        animate={{
          rotateX: [2, -2, 2],
          rotateY: [-5, 5, -5],
          transformPerspective: 500,
        }}
        transition={{ duration: 6, repeat: Infinity, ease: 'easeInOut' }}
        style={{
          textShadow: `
            0 1px 0 #ccc, 0 2px 0 #c9c9c9, 0 3px 0 #bbb,
            0 4px 0 #b9b9b9, 0 5px 0 #aaa, 0 6px 1px rgba(0,0,0,0.1),
            0 0 5px rgba(0,0,0,0.1), 0 1px 3px rgba(0,0,0,0.3),
            0 3px 5px rgba(0,0,0,0.2), 0 5px 10px rgba(0,0,0,0.25)
          `,
        }}
      >
        {text}
      </motion.h1>
    </div>
  );
}
```

---

## 5. Typewriter Effects

### Classic Typewriter
```tsx
function Typewriter({ texts, speed = 80, deleteSpeed = 40, pause = 2000 }: {
  texts: string[];
  speed?: number;
  deleteSpeed?: number;
  pause?: number;
}) {
  const [textIndex, setTextIndex] = useState(0);
  const [charIndex, setCharIndex] = useState(0);
  const [deleting, setDeleting] = useState(false);

  useEffect(() => {
    const currentText = texts[textIndex];

    const timeout = setTimeout(() => {
      if (!deleting) {
        if (charIndex < currentText.length) {
          setCharIndex(c => c + 1);
        } else {
          setTimeout(() => setDeleting(true), pause);
        }
      } else {
        if (charIndex > 0) {
          setCharIndex(c => c - 1);
        } else {
          setDeleting(false);
          setTextIndex((textIndex + 1) % texts.length);
        }
      }
    }, deleting ? deleteSpeed : speed);

    return () => clearTimeout(timeout);
  }, [charIndex, deleting, textIndex, texts, speed, deleteSpeed, pause]);

  return (
    <span className="font-mono">
      {texts[textIndex].slice(0, charIndex)}
      <motion.span
        animate={{ opacity: [1, 0] }}
        transition={{ duration: 0.5, repeat: Infinity }}
        className="inline-block w-[2px] h-[1em] bg-current ml-1 align-middle"
      />
    </span>
  );
}
```

### Scramble/Decrypt Text
```tsx
function ScrambleText({ text, trigger }: { text: string; trigger: boolean }) {
  const chars = '!@#$%^&*()_+-=[]{}|;:,.<>?/~`abcdefghijklmnopqrstuvwxyz';
  const [display, setDisplay] = useState(text);
  const intervalRef = useRef<ReturnType<typeof setInterval>>();

  useEffect(() => {
    if (!trigger) {
      setDisplay(text);
      return;
    }

    let iterations = 0;
    const maxIterations = 12;

    intervalRef.current = setInterval(() => {
      setDisplay(
        text
          .split('')
          .map((char, i) => {
            if (i < iterations / maxIterations * text.length) return text[i];
            return chars[Math.floor(Math.random() * chars.length)];
          })
          .join('')
      );

      iterations++;
      if (iterations >= maxIterations) {
        clearInterval(intervalRef.current);
        setDisplay(text);
      }
    }, 40);

    return () => clearInterval(intervalRef.current);
  }, [text, trigger]);

  return <span className="font-mono">{display}</span>;
}
```

---

## 6. Glitch & Distort

### Glitch Text (CSS + JS)
```tsx
function GlitchText({ text }: { text: string }) {
  return (
    <div className="relative inline-block">
      <span className="relative z-10">{text}</span>

      {/* Red channel offset */}
      <motion.span
        className="absolute inset-0 text-red-500 opacity-70"
        animate={{ x: [0, -2, 3, -1, 0], y: [0, 1, -2, 1, 0] }}
        transition={{ duration: 0.3, repeat: Infinity, repeatDelay: 2 }}
        style={{ clipPath: 'inset(30% 0 40% 0)' }}
      >
        {text}
      </motion.span>

      {/* Blue channel offset */}
      <motion.span
        className="absolute inset-0 text-blue-500 opacity-70"
        animate={{ x: [0, 2, -3, 1, 0], y: [0, -1, 2, -1, 0] }}
        transition={{ duration: 0.3, repeat: Infinity, repeatDelay: 2.5 }}
        style={{ clipPath: 'inset(60% 0 10% 0)' }}
      >
        {text}
      </motion.span>
    </div>
  );
}
```

### Squish & Stretch
```css
.squish-text {
  display: inline-block;
  animation: squish 3s ease-in-out infinite;
}

@keyframes squish {
  0%, 100% { transform: scale(1, 1); }
  10% { transform: scale(1.3, 0.7); }
  20% { transform: scale(0.8, 1.2); }
  30% { transform: scale(1.1, 0.9); }
  40% { transform: scale(1, 1); }
}
```

### Wave Distortion
```tsx
function WaveText({ text }: { text: string }) {
  return (
    <span className="inline-flex">
      {text.split('').map((char, i) => (
        <motion.span
          key={i}
          animate={{ y: [0, -8, 0] }}
          transition={{
            duration: 1.5,
            repeat: Infinity,
            delay: i * 0.08,
            ease: 'easeInOut',
          }}
          className={char === ' ' ? 'w-[0.3em]' : ''}
        >
          {char}
        </motion.span>
      ))}
    </span>
  );
}
```

---

## 7. Text as Texture / Background

### Giant Background Text
```css
.bg-text {
  position: absolute;
  font-size: 15vw;
  font-weight: 900;
  color: rgba(0, 0, 0, 0.03);
  white-space: nowrap;
  pointer-events: none;
  user-select: none;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  letter-spacing: -0.04em;
}
```

### Repeating Text Pattern
```tsx
function TextPattern({ text, rows = 5 }: { text: string; rows?: number }) {
  return (
    <div className="absolute inset-0 overflow-hidden opacity-[0.03] select-none pointer-events-none"
      aria-hidden="true">
      {Array.from({ length: rows * 2 }).map((_, i) => (
        <motion.div
          key={i}
          className="text-4xl font-black whitespace-nowrap leading-none"
          animate={{ x: i % 2 === 0 ? ['0%', '-50%'] : ['-50%', '0%'] }}
          transition={{ duration: 20 + i * 2, repeat: Infinity, ease: 'linear' }}
        >
          {Array.from({ length: 20 }).map(() => text).join(' ')}
        </motion.div>
      ))}
    </div>
  );
}
```

---

## 8. Split & Reveal Text

### Split Line Reveal
```tsx
function SplitReveal({ children }: { children: string }) {
  return (
    <div className="overflow-hidden">
      <motion.div
        initial={{ y: '100%' }}
        whileInView={{ y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.8, ease: [0.76, 0, 0.24, 1] }}
      >
        {children}
      </motion.div>
    </div>
  );
}
```

### Alternating Direction Reveal
```tsx
function StaggeredReveal({ lines }: { lines: string[] }) {
  return (
    <div className="space-y-2">
      {lines.map((line, i) => (
        <div key={i} className="overflow-hidden">
          <motion.p
            initial={{ x: i % 2 === 0 ? '-100%' : '100%' }}
            whileInView={{ x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.7, delay: i * 0.15, ease: [0.76, 0, 0.24, 1] }}
            className="text-2xl font-medium"
          >
            {line}
          </motion.p>
        </div>
      ))}
    </div>
  );
}
```

---

## 9. Number Animations (Counting)

### Odometer / Slot Machine Numbers
```tsx
function OdometerNumber({ value, digits = 4 }: { value: number; digits?: number }) {
  const paddedValue = String(value).padStart(digits, '0');

  return (
    <div className="flex font-mono tabular-nums">
      {paddedValue.split('').map((digit, i) => (
        <div key={i} className="relative h-[1.2em] w-[0.6em] overflow-hidden">
          <AnimatePresence mode="popLayout">
            <motion.span
              key={`${i}-${digit}`}
              initial={{ y: '100%' }}
              animate={{ y: 0 }}
              exit={{ y: '-100%' }}
              transition={{ type: 'spring', stiffness: 300, damping: 30 }}
              className="absolute inset-0 flex items-center justify-center"
            >
              {digit}
            </motion.span>
          </AnimatePresence>
        </div>
      ))}
    </div>
  );
}
```

### Flip Clock Digits
```tsx
function FlipDigit({ digit }: { digit: string }) {
  const prevDigit = usePrevious(digit);

  return (
    <div className="relative w-12 h-16 bg-gray-900 rounded overflow-hidden">
      {/* Top half */}
      <div className="absolute inset-x-0 top-0 h-1/2 bg-gray-800 flex items-end justify-center pb-1
        border-b border-gray-900">
        <span className="text-2xl font-bold text-white">{digit}</span>
      </div>
      {/* Bottom half */}
      <div className="absolute inset-x-0 bottom-0 h-1/2 bg-gray-800 flex items-start justify-center pt-1">
        <AnimatePresence mode="popLayout">
          <motion.span
            key={digit}
            initial={{ rotateX: -90, opacity: 0 }}
            animate={{ rotateX: 0, opacity: 1 }}
            exit={{ rotateX: 90, opacity: 0 }}
            className="text-2xl font-bold text-white"
          >
            {digit}
          </motion.span>
        </AnimatePresence>
      </div>
    </div>
  );
}
```

---

## 10. Highlight & Underline Animations

### Animated Underline
```css
.underline-reveal {
  position: relative;
}
.underline-reveal::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 2px;
  background: currentColor;
  transform: scaleX(0);
  transform-origin: right;
  transition: transform 0.3s ease;
}
.underline-reveal:hover::after {
  transform: scaleX(1);
  transform-origin: left;
}
```

### Highlight Marker
```css
.highlight-marker {
  background: linear-gradient(120deg, #ffd700 0%, #ffd700 100%);
  background-repeat: no-repeat;
  background-size: 100% 30%;
  background-position: 0 85%;
  transition: background-size 0.3s ease;
}
.highlight-marker:hover {
  background-size: 100% 70%;
}
```

### Circle Highlight Reveal
```tsx
function CircleHighlight({ children }: { children: string }) {
  return (
    <span className="relative inline-block">
      <motion.span
        className="absolute inset-0 bg-primary/20 -z-10"
        initial={{ clipPath: 'circle(0% at 0% 50%)' }}
        whileInView={{ clipPath: 'circle(100% at 50% 50%)' }}
        viewport={{ once: true }}
        transition={{ duration: 0.8, ease: [0.22, 1, 0.36, 1] }}
      />
      {children}
    </span>
  );
}
```

---

## 11. CSS Text Effects Quick Reference

```css
/* Neon glow */
.text-neon {
  text-shadow:
    0 0 5px currentColor,
    0 0 10px currentColor,
    0 0 20px currentColor,
    0 0 40px currentColor;
}

/* Stroke/Outline */
.text-outline {
  -webkit-text-stroke: 2px currentColor;
  -webkit-text-fill-color: transparent;
}

/* Reflection */
.text-reflection {
  -webkit-box-reflect: below -10px linear-gradient(transparent, rgba(0,0,0,0.2));
}

/* Blur in (CSS only, non-animated) */
.text-blur {
  filter: blur(0px);
  transition: filter 0.4s;
}
.text-blur:hover {
  filter: blur(2px);
}

/* Knockout / punch-through */
.text-knockout {
  mix-blend-mode: difference;
  color: white;
}

/* Text shadow depth */
.text-shadow-depth {
  text-shadow:
    0 0 2px rgba(0,0,0,0.1),
    0 2px 4px rgba(0,0,0,0.1),
    0 4px 8px rgba(0,0,0,0.1),
    0 8px 16px rgba(0,0,0,0.1);
}

/* Clip text to background */
.text-clip-bg {
  background: inherit;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
```

---

## Quick Index

| Category | Effects |
|----------|---------|
| Kinetic Typography | Stagger Chars, Word Reveal, Marquee, Variable Weight, Rotating Words |
| Gradient Text | Linear, Radial, Rainbow, Gold, Animated Flow |
| Text Masking | Image Mask, Video Mask, Reveal Mask |
| 3D Text | Perspective 3D, Layered Extrusion, Floating 3D |
| Typewriter | Classic Typewriter, Scramble/Decrypt |
| Glitch & Distort | RGB Split, Squish & Stretch, Wave Distortion |
| Text as Texture | Giant BG Text, Repeating Pattern |
| Split & Reveal | Line Reveal, Alternating Direction, Clip Reveal |
| Number Animations | Odometer, Flip Clock, Animated Counter |
| Highlights | Animated Underline, Marker, Circle Reveal |
| CSS One-Liners | Neon, Stroke, Reflection, Blur, Knockout, Shadow |
