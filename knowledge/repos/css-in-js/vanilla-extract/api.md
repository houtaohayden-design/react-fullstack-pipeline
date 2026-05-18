# vanilla-extract API Reference

> Zero-runtime Stylesheets-in-TypeScript. Write styles in `.css.ts` files, evaluated at build time. Locally scoped class names, CSS variables, keyframes, and fonts. Type-safe via CSSType.

## Setup

```bash
npm install @vanilla-extract/css
npm install --save-dev @vanilla-extract/vite-plugin  # or webpack/esbuild/next/rollup
```

File convention: `*.css.ts` — these files are evaluated at build time and produce static `.css` output. None of the TypeScript code appears in the final bundle.

```ts
// vite.config.ts
import { vanillaExtractPlugin } from '@vanilla-extract/vite-plugin';
export default defineConfig({ plugins: [vanillaExtractPlugin()] });
```

## Package Map

| Package | Purpose |
|---------|---------|
| `@vanilla-extract/css` | Core: `style`, `createTheme`, `createVar`, `keyframes`, `fontFace`, `globalStyle` |
| `@vanilla-extract/recipes` | Component variant system (like CVA/Stitches) |
| `@vanilla-extract/sprinkles` | Atomic CSS utility framework (like Tailwind) |
| `@vanilla-extract/dynamic` | Runtime dynamic theming (`assignInlineVars`, `setElementVars`) |

Bundler plugins: `vite-plugin`, `webpack-plugin`, `esbuild-plugin`, `next-plugin`, `rollup-plugin`, `parcel-transformer`, `turbopack-plugin`.

---

## @vanilla-extract/css — Core API

### style()

Creates a hashed, locally scoped class name. Returns `string`.

```ts
import { style } from '@vanilla-extract/css';

export const button = style({
  backgroundColor: 'blue',
  color: 'white',
  padding: '10px 20px',
  ':hover': { backgroundColor: 'darkblue' }
});

// Composition: merge multiple styles
export const primary = style([button, { fontWeight: 'bold' }]);
```

| Param | Type | Description |
|-------|------|-------------|
| `rule` | `StyleRule \| Array<StyleRule \| string>` | CSS properties (camelCase), pseudo-selectors, media queries. Single object or composition array |
| `debugId?` | `string` | Optional debug label for the generated class name |

**StyleRule** supports: standard CSS properties (via CSSType), pseudo-selectors (`:hover`, `:focus`, `:active`, `:focus-visible`, `:disabled`, `::before`, `::after`, etc.), `@media` queries, `@supports` queries, `@container` queries, `@layer` nesting, `@starting-style`, `selectors` map for complex selectors, `vars` for local CSS variable assignments.

### globalStyle()

Injects global (unscoped) CSS. No return value.

```ts
import { globalStyle } from '@vanilla-extract/css';

globalStyle('body', { margin: 0, fontFamily: 'sans-serif' });
globalStyle('a:hover', { textDecoration: 'underline' });
```

| Param | Type | Description |
|-------|------|-------------|
| `selector` | `string` | CSS selector (global, not scoped) |
| `rule` | `GlobalStyleRule` | CSS properties with queries/pseudos |

### styleVariants()

Creates a map of variant class names from a data object or style map.

```ts
import { styleVariants } from '@vanilla-extract/css';

// From a style map
export const buttonSize = styleVariants({
  small: { padding: '4px 8px', fontSize: 12 },
  medium: { padding: '8px 16px', fontSize: 14 },
  large: { padding: '12px 24px', fontSize: 16 }
});
// => { small: "xxx_1", medium: "xxx_2", large: "xxx_3" }

// From a data array with mapping function
const colors = { red: '#ff0000', blue: '#0000ff', green: '#00ff00' };
export const bgColor = styleVariants(colors, (color) => ({
  backgroundColor: color
}));
```

| Overload | Signature |
|----------|-----------|
| Map-based | `styleVariants<M>(styleMap: M, debugId?): Record<keyof M, string>` |
| Data+mapper | `styleVariants<D, K>(data: D, mapFn: (v: D[K], k: K) => StyleRule, debugId?): Record<keyof D, string>` |

### createTheme() / createGlobalTheme()

`createTheme` creates a scoped theme class (returns class name + vars tuple or just class name). `createGlobalTheme` applies theme to a global selector.

```ts
import { createTheme, createGlobalTheme } from '@vanilla-extract/css';

// Scoped theme
export const [themeClass, vars] = createTheme({
  color: { brand: 'blue', text: '#333' },
  space: { small: '4px', medium: '8px' }
});
// themeClass = "theme_xxx", vars.color.brand = "var(--xxx)"

// Global theme on :root
createGlobalTheme(':root', {
  color: { brand: 'blue' }
});

// With existing contract
const contract = createThemeContract({ color: { brand: null } });
const lightClass = createTheme(contract, { color: { brand: 'blue' } }, 'light');
```

| Function | Signature | Returns |
|----------|-----------|---------|
| `createTheme(tokens, debugId?)` | Creates contract + theme class | `[className, vars]` |
| `createTheme(contract, tokens, debugId?)` | Creates theme class with existing contract | `className` |
| `createGlobalTheme(selector, tokens)` | Creates contract + applies globally | `contract` |
| `createGlobalTheme(selector, contract, tokens)` | Applies tokens with existing contract globally | `void` |

Tokens support `@layer` key: `createTheme({ '@layer': 'base', color: { brand: 'blue' } })`.

### createThemeContract() / createGlobalThemeContract()

Creates a typed contract of CSS variable references without assigning values. Used to share types across themes.

```ts
import { createThemeContract } from '@vanilla-extract/css';

export const vars = createThemeContract({
  color: { brand: null, text: null },
  space: { small: null, medium: null, large: null }
});
// vars.color.brand => "var(--color-brand-xxx)"
```

`createGlobalThemeContract` lets you specify custom variable names via a mapping function:

```ts
const vars = createGlobalThemeContract({
  color: { brand: 'brand-color' }  // uses --brand-color
}, (value, path) => `prefix-${value}`);
```

### createVar() / createGlobalVar() / fallbackVar() / assignVars()

CSS custom property management:

```ts
import { createVar, createGlobalVar, fallbackVar, assignVars } from '@vanilla-extract/css';

// Scoped variable with type declaration
const accentVar = createVar({ syntax: '<color>', inherits: false, initialValue: 'blue' });

// Global variable
const globalAccent = createGlobalVar('accent-color', { syntax: '<color>', inherits: true });

// Fallback chain
const color = fallbackVar(accentVar, 'red');

// Assign values to contract
const styles = assignVars(contract, { color: { brand: 'navy' } });
// => { "var(--xxx)": "navy" } — usable in style() `vars` property
```

| Function | Purpose |
|----------|---------|
| `createVar(debugId?)` | Scoped CSS variable ref, no type declaration |
| `createVar(declaration, debugId?)` | Scoped CSS variable with `@property` declaration |
| `createGlobalVar(name, declaration?)` | Global CSS variable, optional `@property` |
| `fallbackVar(var, fallback)` | `var(--x, fallback)` fallback chain |
| `assignVars(contract, tokens)` | Assigns token values to contract vars — returns `{ [varFunc]: value }` |

### fontFace() / globalFontFace()

```ts
import { fontFace, globalFontFace } from '@vanilla-extract/css';

// Scoped font (returns hashed font-family name)
const myFont = fontFace({
  src: 'url("/fonts/MyFont.woff2") format("woff2")',
  fontWeight: 400
});

// Global font
globalFontFace('MyFont', {
  src: 'url("/fonts/MyFont.woff2") format("woff2")',
  fontWeight: 400
});
```

### keyframes() / globalKeyframes()

```ts
import { keyframes } from '@vanilla-extract/css';

const rotate = keyframes({
  '0%': { transform: 'rotate(0deg)' },
  '100%': { transform: 'rotate(360deg)' }
});
// Use: style({ animationName: rotate })
```

### layer() / globalLayer()

```ts
import { layer, globalLayer } from '@vanilla-extract/css';

const resetLayer = layer('reset');  // hashed name
const baseLayer = globalLayer('base');  // unhashed name
const nestedLayer = layer({ parent: 'base' }, 'nested');
```

### createContainer() / createViewTransition()

```ts
import { createContainer, createViewTransition } from '@vanilla-extract/css';

const containerName = createContainer('sidebar');  // hashed container name
const vtName = createViewTransition('card');  // hashed view-transition-name
```

### File-scope utilities

```ts
import { hasFileScope, setFileScope, endFileScope } from '@vanilla-extract/css/fileScope';
// For runtime/browser builds, manage file scopes manually
```

### StyleRule Type Reference

```ts
StyleRule = {
  // CSS properties (camelCase via CSSType)
  backgroundColor?: string | CSSVarFunction;
  padding?: string | number;
  // ...all CSS properties...

  // Pseudo selectors
  ':hover'?: CSSProperties;
  ':focus'?: CSSProperties;
  ':active'?: CSSProperties;
  ':focus-visible'?: CSSProperties;
  ':disabled'?: CSSProperties;
  '::before'?: CSSProperties;
  '::after'?: CSSProperties;
  // ...and all simple pseudos

  // At-rules
  '@media'?: { [query: string]: StyleRule };
  '@supports'?: { [query: string]: StyleRule };
  '@container'?: { [query: string]: StyleRule };
  '@layer'?: { [name: string]: StyleRule };
  '@starting-style'?: StyleRule;

  // Complex selectors
  selectors?: { [selector: string]: StyleRule };

  // CSS variable assignments
  vars?: { [key: string]: string };
};
```

---

## @vanilla-extract/recipes — Variant System

```bash
npm install @vanilla-extract/recipes
```

### recipe()

Creates a type-safe variant function — like CVA.

```ts
import { recipe } from '@vanilla-extract/recipes';

export const button = recipe({
  base: {
    borderRadius: 6,
    fontWeight: 600,
    padding: '8px 16px'
  },
  variants: {
    color: {
      primary: { background: 'blue', color: 'white' },
      secondary: { background: 'gray', color: 'white' },
      danger: { background: 'red', color: 'white' }
    },
    size: {
      small: { padding: '4px 8px', fontSize: 12 },
      medium: { padding: '8px 16px', fontSize: 14 },
      large: { padding: '12px 24px', fontSize: 16 }
    }
  },
  defaultVariants: {
    color: 'primary',
    size: 'medium'
  },
  compoundVariants: [
    { variants: { color: 'danger', size: 'large' }, style: { textTransform: 'uppercase' } }
  ]
});

// Usage
button();                          // base + defaults = "class1 class2"
button({ color: 'secondary' });    // "class1 class3"
button({ color: 'danger', size: 'large' }); // "class1 class4 class5 class6"

// RuntimeFn properties
button.variants();  // ['color', 'size']
button.classNames;  // { base: "xxx", variants: { color: { primary: "yyy", ... }, size: {...} } }
```

| Option | Type | Description |
|--------|------|-------------|
| `base` | `StyleRule \| string` | Base styles applied always |
| `variants` | `Record<string, Record<string, StyleRule>>` | Variant groups with styles per value |
| `defaultVariants` | `Record<string, string>` | Default variant selections |
| `compoundVariants` | `Array<{ variants, style }>` | Conditional styles when variant combo matches |
| `debugId?` | `string` | Debug label |

### RecipeVariants type helper

```ts
import { recipe, type RecipeVariants } from '@vanilla-extract/recipes';

const button = recipe({ variants: { color: { primary: {}, secondary: {} }, size: { sm: {}, lg: {} } } });
type ButtonVariants = RecipeVariants<typeof button>;
// => { color?: 'primary' | 'secondary'; size?: 'sm' | 'lg' }
```

---

## @vanilla-extract/sprinkles — Atomic CSS

```bash
npm install @vanilla-extract/sprinkles
```

### defineProperties()

Defines atomic CSS properties with optional conditions (media queries, responsive arrays, shorthands).

```ts
import { defineProperties } from '@vanilla-extract/sprinkles';

const responsiveProperties = defineProperties({
  conditions: {
    mobile: {},
    tablet: { '@media': 'screen and (min-width: 768px)' },
    desktop: { '@media': 'screen and (min-width: 1024px)' }
  },
  defaultCondition: 'mobile',
  properties: {
    display: ['none', 'flex', 'block', 'inline'],
    flexDirection: ['row', 'column'],
    paddingTop: { small: 4, medium: 8, large: 16 },
    paddingBottom: { small: 4, medium: 8, large: 16 }
  },
  shorthands: {
    paddingY: ['paddingTop', 'paddingBottom']
  }
});
```

| Option | Type | Description |
|--------|------|-------------|
| `properties` | `Record<string, string[] \| Record<string, CSSPropertyValue>>` | Atomic CSS values |
| `conditions` | `Record<string, { '@media'?, '@supports'?, '@container'?, 'selector'? }>` | Breakpoint/conditional rules |
| `defaultCondition` | `string \| string[] \| false` | Default condition key |
| `responsiveArray` | `string[] & { length: N }` | Media query order for responsive array shorthand |
| `shorthands` | `Record<string, string[]>` | Property aliases that expand to multiple properties |
| `@layer` | `string` | CSS layer name for generated styles |

### createSprinkles()

Creates a sprinkles function from defined properties — composes atomic classes.

```ts
import { createSprinkles } from '@vanilla-extract/sprinkles';

const sprinkles = createSprinkles(responsiveProperties, colorProperties);

// Usage
sprinkles({ display: 'flex', paddingY: 'medium' });
// Responsive array: [mobile, tablet, desktop]
sprinkles({ display: ['block', 'flex', 'none'] });
// Conditional object
sprinkles({ display: { mobile: 'flex', desktop: 'none' } });

// Inspect available properties
sprinkles.properties; // Set<string>
```

### ConditionalValue & createNormalizeValueFn / createMapValueFn

```ts
import { createNormalizeValueFn, createMapValueFn } from '@vanilla-extract/sprinkles';
import type { ConditionalValue } from '@vanilla-extract/sprinkles';

type ResponsiveValue = ConditionalValue<typeof responsiveProperties, string>;

const normalize = createNormalizeValueFn(responsiveProperties);
const mapValue = createMapValueFn(responsiveProperties);
```

---

## @vanilla-extract/dynamic — Runtime Theming

```bash
npm install @vanilla-extract/dynamic
```

### assignInlineVars()

Generates an inline style object with CSS custom properties for runtime use.

```ts
import { assignInlineVars } from '@vanilla-extract/dynamic';

// Direct vars
<div style={assignInlineVars({ [myVar]: 'red' })} />

// With theme contract
<div style={assignInlineVars(themeContract, { color: { brand: 'red' } })} />
```

Returns an object with a custom `toString()` that produces `varName:value;varName:value`.

### setElementVars()

Sets CSS custom properties on a DOM element at runtime.

```ts
import { setElementVars } from '@vanilla-extract/dynamic';

setElementVars(document.body, { [myVar]: 'red' });
setElementVars(element, themeContract, { color: { brand: 'blue' } });
```

---

## Bundler Plugin APIs

Each bundler plugin accepts configuration:

```ts
// vite-plugin
vanillaExtractPlugin({ identifiers: 'short' | 'debug' | CustomFn })

// esbuild-plugin  
vanillaExtractPlugin({ identifiers: 'short', esbuildOptions: {} })

// webpack-plugin
new VanillaExtractPlugin({ identifiers: 'short' })

// next-plugin
const withVanillaExtract = createVanillaExtractPlugin();
```

`identifiers` option: `'short'` (prod, short hashes), `'debug'` (dev, readable class names), or a custom function `({ hash, filePath, debugId, packageName }) => string`.
