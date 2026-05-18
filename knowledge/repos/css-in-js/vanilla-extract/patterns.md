# vanilla-extract Patterns

## Library Positioning

vanilla-extract is a **zero-runtime CSS-in-TypeScript** library by SEEK. Styles are written in `.css.ts` files and evaluated at build time, producing static CSS files with zero JavaScript bundle overhead. Think of it as "CSS Modules + TypeScript + CSS Custom Properties" — all with full type safety.

**It is NOT** a runtime CSS-in-JS library (no runtime overhead, unlike styled-components/emotion). It is also NOT a utility-first framework (though Sprinkles adds that layer optionally).

### When to Use
- You want type-safe CSS without runtime cost
- You need a design token / theme system with compile-time type checking
- You want locally scoped styles (like CSS Modules) but in TypeScript
- You are building a design system with strict theme contracts
- You need multi-theme support with type-safe variables

### When NOT to Use
- You prefer writing plain CSS/Sass files directly
- You want zero-config setup (vanilla-extract requires bundler plugin)
- You need dynamic runtime styles for everything (use `@vanilla-extract/dynamic` sparingly)

### Ecosystem Position
| Competitor | Runtime | Type Safety | Theming | Atomic CSS |
|------------|---------|-------------|---------|------------|
| vanilla-extract | Zero | Full (TypeScript) | First-class (contracts) | Via Sprinkles |
| styled-components | Runtime | Partial | ThemeProvider | No |
| Panda CSS | Zero | Full | Yes | Built-in (recipes) |
| Tailwind | Zero | None | Config | Built-in |
| CSS Modules | Zero | None | CSS vars | No |
| Stitches | Near-zero | Full | First-class | Built-in |

## Architecture

### Build-Time Evaluation
```
.css.ts source → bundler plugin evaluates → static .css output
                                         → JS file with class name strings
```

All style functions (`style()`, `createVar()`, `keyframes()`, etc.) run at build time. The bundler plugin:
1. Identifies `.css.ts` files
2. Evaluates them in a Node VM
3. Collects all CSS output
4. Emits static `.css` files
5. Replaces the module with string exports

### File Convention
- Files named `*.css.ts` are processed by the plugin
- Each file creates its own scope for hashed identifiers
- Imports from `@vanilla-extract/css` trigger the build-time evaluation

## Core Patterns

### Pattern 1: Theme Contract Architecture

The recommended approach for design systems:

```ts
// 1. Define the contract (shared between themes)
// contract.css.ts
import { createThemeContract } from '@vanilla-extract/css';

export const vars = createThemeContract({
  colors: {
    background: null,
    text: null,
    primary: null,
    accent: null
  },
  space: {
    xs: null, sm: null, md: null, lg: null, xl: null
  },
  radii: {
    sm: null, md: null, lg: null
  },
  fonts: {
    body: null, heading: null
  }
});
```

```ts
// 2. Define themes implementing the contract
// themes.css.ts
import { createTheme } from '@vanilla-extract/css';
import { vars } from './contract.css.ts';

export const lightTheme = createTheme(vars, {
  colors: { background: '#fff', text: '#111', primary: '#06c', accent: '#f0f' },
  space: { xs: '4px', sm: '8px', md: '16px', lg: '24px', xl: '48px' },
  radii: { sm: '2px', md: '4px', lg: '8px' },
  fonts: { body: 'Inter, sans-serif', heading: 'Inter, sans-serif' }
});

export const darkTheme = createTheme(vars, {
  colors: { background: '#111', text: '#eee', primary: '#39f', accent: '#f6f' },
  space: { xs: '4px', sm: '8px', md: '16px', lg: '24px', xl: '48px' },
  radii: { sm: '2px', md: '4px', lg: '8px' },
  fonts: { body: 'Inter, sans-serif', heading: 'Inter, sans-serif' }
});
```

```ts
// 3. Consume contract vars in components
// button.css.ts
import { style } from '@vanilla-extract/css';
import { vars } from './contract.css.ts';

export const button = style({
  backgroundColor: vars.colors.primary,
  color: vars.colors.text,
  padding: `${vars.space.sm} ${vars.space.md}`,
  borderRadius: vars.radii.md,
  fontFamily: vars.fonts.body
});
```

```tsx
// 4. Apply theme in React
// App.tsx
import { lightTheme, darkTheme } from './themes.css.ts';

function App() {
  const [isDark, setIsDark] = useState(false);
  return (
    <div className={isDark ? darkTheme : lightTheme}>
      <button className={button}>Click</button>
    </div>
  );
}
```

### Pattern 2: Recipe Variants (Component API)

`@vanilla-extract/recipes` provides a pattern similar to `cva` / Stitches variants:

```ts
// button.css.ts
import { recipe, type RecipeVariants } from '@vanilla-extract/recipes';
import { vars } from './contract.css.ts';

export const button = recipe({
  base: {
    borderRadius: vars.radii.md,
    fontFamily: vars.fonts.body,
    cursor: 'pointer',
    transition: 'all 200ms ease',
    ':disabled': { opacity: 0.5, cursor: 'not-allowed' }
  },
  variants: {
    variant: {
      primary: { background: vars.colors.primary, color: '#fff' },
      secondary: { background: 'transparent', border: `1px solid ${vars.colors.primary}` },
      ghost: { background: 'transparent' }
    },
    size: {
      sm: { padding: `${vars.space.xs} ${vars.space.sm}`, fontSize: 12 },
      md: { padding: `${vars.space.sm} ${vars.space.md}`, fontSize: 14 },
      lg: { padding: `${vars.space.md} ${vars.space.lg}`, fontSize: 16 }
    }
  },
  defaultVariants: { variant: 'primary', size: 'md' },
  compoundVariants: [
    { variants: { variant: 'ghost', size: 'lg' }, style: { fontWeight: 'bold' } }
  ]
});

export type ButtonVariants = RecipeVariants<typeof button>;
```

```tsx
// Component consumption
import { button, type ButtonVariants } from './button.css.ts';

interface ButtonProps extends ButtonVariants {
  label: string;
  className?: string;
}

function Button({ label, variant, size, className }: ButtonProps) {
  return <button className={`${button({ variant, size })} ${className ?? ''}`.trim()}>{label}</button>;
}
```

### Pattern 3: Sprinkles + Recipes Hybrid

Combine atomic CSS (Sprinkles) for layout/spacing with Recipes for component variants:

```ts
// sprinkles.css.ts
import { defineProperties, createSprinkles } from '@vanilla-extract/sprinkles';
import { vars } from './contract.css.ts';

const space = { none: 0, xs: vars.space.xs, sm: vars.space.sm, md: vars.space.md, lg: vars.space.lg };

const responsive = defineProperties({
  conditions: { mobile: {}, tablet: { '@media': 'screen and (min-width: 768px)' }, desktop: { '@media': 'screen and (min-width: 1024px)' } },
  defaultCondition: 'mobile',
  responsiveArray: ['mobile', 'tablet', 'desktop'] as const,
  properties: {
    display: ['none', 'block', 'flex', 'grid', 'inline-flex'],
    flexDirection: ['row', 'column', 'row-reverse'],
    gap: space,
    padding: space,
    margin: space
  },
  shorthands: { p: ['padding'], m: ['margin'], px: ['paddingLeft', 'paddingRight'], py: ['paddingTop', 'paddingBottom'] }
});

const colorProps = defineProperties({
  properties: {
    background: vars.colors,
    color: vars.colors
  }
});

export const sprinkles = createSprinkles(responsive, colorProps);
```

```tsx
// Box component using sprinkles
function Box({ children, ...props }: Parameters<typeof sprinkles>[0] & { children: React.ReactNode }) {
  return <div className={sprinkles(props)}>{children}</div>;
}

// Usage
<Box display="flex" py="md" gap="sm">
  <Box p="md" background="primary">Card</Box>
</Box>
```

### Pattern 4: Component + Composition Style

Using `style()` composition arrays (inherits base + overrides):

```ts
const base = style({ padding: 8, borderRadius: 4 });
const primary = style([base, { background: 'blue' }]);
const large = style([base, { padding: 16, fontSize: 18 }]);
// Composing multiple: the later styles in the array win on property conflicts
const primaryLarge = style([base, primary, large]);
```

### Pattern 5: Runtime Dynamic Theming

For user-configurable themes at runtime (e.g., color picker):

```ts
import { createThemeContract } from '@vanilla-extract/css';
import { assignInlineVars } from '@vanilla-extract/dynamic';

// Static contract at build time
export const dynamicVars = createThemeContract({
  color: { accent: null, background: null }
});

// At runtime, apply user-chosen values
function ThemedSection({ accentColor, bgColor }: { accentColor: string; bgColor: string }) {
  return (
    <section style={assignInlineVars(dynamicVars, {
      color: { accent: accentColor, background: bgColor }
    })}>
      <h1 style={{ color: dynamicVars.color.accent }}>Themed</h1>
    </section>
  );
}
```

## Styling Approach

### Typed CSS Properties

All CSS properties are type-checked via `csstype`. TypeScript catches invalid values at compile time:

```ts
// TypeScript error: 'bluu' is not a valid color
style({ backgroundColor: 'bluu' });  // ❌ compile error
style({ backgroundColor: 'blue' });   // ✅
```

### String Templates for Dynamic Values

Use template literals to compose CSS values:

```ts
style({ padding: `${vars.space.sm} ${vars.space.md}` });
style({ transform: `translateX(${offset}px)` });  // offset must be known at build time
```

### calc() Expressions

```ts
import { calc } from '@vanilla-extract/css-utils';
// Not a built-in export; use string templates:
style({ width: `calc(100% - ${vars.space.md})` });
```

### CSS Layers

```ts
const reset = globalLayer('reset');
const components = layer('components');

style({
  '@layer': { [components]: { padding: vars.space.md } }
});
```

## Anti-Patterns

### DON'T: Runtime values in style objects
```ts
// ❌ BAD: componentProps.width is unknown at build time
function Box({ width }: { width: number }) {
  return <div className={style({ width })} />;  // won't work
}

// ✅ GOOD: Use inline styles or CSS variables for runtime values
function Box({ width }: { width: number }) {
  return <div style={{ width }} />;
}
```

### DON'T: Style in regular .ts files
```ts
// ❌ BAD: style() in app.tsx — will be stripped at build time
// app.tsx
import { style } from '@vanilla-extract/css';
const foo = style({ color: 'red' });  // Runtime: foo is undefined

// ✅ GOOD: style() only in .css.ts files
// styles.css.ts
export const foo = style({ color: 'red' });
// app.tsx
import { foo } from './styles.css.ts';
```

### DON'T: Over-use dynamic package
The `@vanilla-extract/dynamic` package should be used sparingly for truly dynamic theming only. Most themes should use the static `createTheme` approach.

### DON'T: Export tokens directly from contract before assignment
```ts
// ❌ BAD
export const vars = createThemeContract({ color: { brand: null } });
export default vars.color.brand;  // "var(--xxx)" — no value yet!

// ✅ GOOD: Consume vars only in style() rules where CSS variables resolve
export const heading = style({ color: vars.color.brand });
```

### DON'T: Nest recipes inside recipes
Keep recipes flat. Use composition or compound variants instead of deeply nested variant logic.

## Compatibility

### With Tailwind CSS
**Partial** — vanilla-extract generates static CSS files that coexist with Tailwind. You can use both in the same project, but they are separate systems. Use vanilla-extract for component-level design tokens and Tailwind for utility classes. Sprinkles provides a Tailwind-like API within the vanilla-extract ecosystem.

### With react-bits
**Complementary** — react-bits provides copy-paste animated components. vanilla-extract styles can be applied alongside react-bits components, but react-bits uses CSS/Tailwind by default. To integrate: use vanilla-extract's `style()` for static component styles and apply them via `className`.

### With shadcn/ui
**No direct compatibility** — shadcn/ui is built on Tailwind + Radix. vanilla-extract would replace the styling layer, not supplement it. Use one or the other for your styling foundation.

### With CSS Modules
**Alternative** — vanilla-extract is a direct replacement for CSS Modules, offering the same locally-scoped class names plus type safety, theme contracts, and variants.

### React Version
Framework-agnostic. Works with any framework (React, Vue, Svelte, Solid) or vanilla JS. The CSS output is just static `.css` files. React-specific: the dynamic package helpers work with React inline styles.

### Recommended React Version
`>=16.8` (for hooks-based theme toggling), but the core library works with any React version or framework.
