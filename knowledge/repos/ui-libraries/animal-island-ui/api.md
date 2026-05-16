# animal-island-ui -- API Reference

> Version: 0.8.0 | React >= 17 | TypeScript first

## Setup

```bash
npm install animal-island-ui
```

```tsx
// app entry (main.tsx / _app.tsx / App.tsx)
import 'animal-island-ui/style'; // MUST be JS import (NOT CSS @import) BEFORE any component usage
// Fonts (Nunito / Noto Sans SC / Zen Maru Gothic) are auto-bundled via @fontsource
```

**CRITICAL:** The style import MUST be a JavaScript `import`, NOT a CSS `@import`. Vite resolves package.json `exports` differently for CSS — `@import 'animal-island-ui/style'` in a `.css` file will silently fail. Always put `import 'animal-island-ui/style'` in your JS/TS entry file.

**Deep path imports are blocked** by the package.json `exports` field. Only import from the package root (`animal-island-ui`) or `animal-island-ui/style`. Do NOT import from paths like `animal-island-ui/dist/types/...`.

Peer requirements: `react >= 17.0.0`, `react-dom >= 17.0.0`

## Style

Animal Crossing: New Horizons inspired design -- warm, rounded, nature-themed React UI components with soft colors and playful Nintendo-style 3D button-press interactions.

---

## Components (18 total)

### Interactive (8)

#### Button
Pill-shaped button with 5 visual types and 3 sizes. Signature Nintendo-style 3D bottom shadow that compresses on click.

```ts
type ButtonType     = 'primary' | 'default' | 'dashed' | 'text' | 'link';
type ButtonSize     = 'small' | 'middle' | 'large';
type ButtonHTMLType = 'submit' | 'reset' | 'button';

interface ButtonProps extends Omit<React.ButtonHTMLAttributes<HTMLButtonElement>, 'type'> {
  type?: ButtonType;          // default 'default'
  size?: ButtonSize;          // default 'middle'
  danger?: boolean;           // default false
  ghost?: boolean;            // default false
  block?: boolean;            // default false
  loading?: boolean;          // default false -- diagonal-stripe animation
  disabled?: boolean;         // default false
  icon?: React.ReactNode;
  htmlType?: ButtonHTMLType;  // default 'button'
  children?: React.ReactNode;
}
```

```tsx
<Button type="primary" onClick={save}>Save</Button>
<Button type="primary" danger loading>Deleting...</Button>
<Button type="dashed" icon={<PlusIcon />} size="large" block>Add</Button>
<Button type="text">Cancel</Button>
```

---

#### Input
Pill-shaped input with prefix/suffix, clear button, and status indicators. Focus ring is yellow (#ffcc00), not blue.

```ts
type InputSize = 'small' | 'middle' | 'large';

interface InputProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size' | 'prefix'> {
  size?: InputSize;                  // default 'middle'
  prefix?: React.ReactNode;
  suffix?: React.ReactNode;
  allowClear?: boolean;              // default false
  status?: 'error' | 'warning';
  onChange?: React.ChangeEventHandler<HTMLInputElement>;
  onClear?: () => void;
}
```

```tsx
<Input placeholder="Your name" allowClear />
<Input size="large" prefix={<SearchIcon />} value={q} onChange={e => setQ(e.target.value)} />
<Input status="error" suffix="@gmail.com" />
```

---

#### Switch
Toggle switch with 3D floating handle. Supports inner text (ON/OFF labels) and loading state.

```ts
type SwitchSize = 'small' | 'default';

interface SwitchProps {
  checked?: boolean;                  // controlled
  defaultChecked?: boolean;           // default false
  size?: SwitchSize;                  // default 'default'
  disabled?: boolean;                 // default false
  loading?: boolean;                  // default false
  checkedChildren?: React.ReactNode;
  unCheckedChildren?: React.ReactNode;
  onChange?: (checked: boolean) => void;
  className?: string;
}
```

```tsx
<Switch defaultChecked onChange={v => console.log(v)} />
<Switch size="small" checkedChildren="ON" unCheckedChildren="OFF" />
<Switch loading disabled />
```

---

#### Modal
Organic blob-shaped modal dialog with built-in typewriter animation for body text. Requires the SVG clipPath `#animal-modal-clip` (shipped internally).

```ts
interface ModalProps {
  open: boolean;                       // REQUIRED
  title?: React.ReactNode;
  width?: number | string;             // default 520
  maskClosable?: boolean;              // default true
  footer?: React.ReactNode | null;     // null = hide footer
  onClose?: () => void;
  onOk?: () => void;
  children?: React.ReactNode;
  className?: string;
  typeSpeed?: number;                  // default 80 (ms/char for built-in typewriter)
  typewriter?: boolean;                // default true -- body plays typewriter on open
}
```

```tsx
const [open, setOpen] = useState(false);
<Modal
  open={open}
  title="Confirm"
  onClose={() => setOpen(false)}
  onOk={() => { submit(); setOpen(false); }}
>
  Proceed to delete this island?
</Modal>
```

---

#### Collapse
CSS-only accordion (no JS height measurement, SSR-safe). Uses CSS grid-row transition with decorative leaf SVG and rotating teal circle icon.

```ts
interface CollapseProps {
  question: React.ReactNode;   // REQUIRED -- header
  answer: React.ReactNode;     // REQUIRED -- body
  defaultExpanded?: boolean;   // default false
  disabled?: boolean;          // default false
  className?: string;
  style?: React.CSSProperties;
}
```

```tsx
<Collapse question="What is Animal Island?" answer="A cozy React UI kit." />
<Collapse defaultExpanded question="FAQ #1" answer={<p>Long rich content...</p>} />
```

---

#### Select
Controlled-only dropdown. Auto-flips position based on viewport space. Click-outside to close is built-in.

```ts
type SelectOption = { key: string; label: string };

interface SelectProps {
  options: SelectOption[];                 // REQUIRED
  value: string;                           // REQUIRED -- controlled-only
  onChange: (key: string) => void;         // REQUIRED
  placeholder?: string;                    // default '请选择'
  disabled?: boolean;                      // default false
}
```

```tsx
const [lang, setLang] = useState('zh');
<Select
  value={lang}
  onChange={setLang}
  options={[
    { key: 'zh', label: '简体中文' },
    { key: 'en', label: 'English' },
    { key: 'ja', label: '日本語' },
  ]}
  placeholder="Choose language"
/>
```

---

#### Tabs
Tab switcher with smooth fade animation and optional leaf wiggle effect. Supports both controlled and uncontrolled modes.

```ts
interface TabItem {
  key: string;
  label: React.ReactNode;
  children: React.ReactNode;
}

interface TabsProps {
  items: TabItem[];           // REQUIRED
  defaultActiveKey?: string;  // default: first tab
  activeKey?: string;         // controlled mode
  onChange?: (key: string) => void;
  className?: string;
  style?: React.CSSProperties;
  leafAnimation?: boolean;    // default true -- active-tab leaf wiggle
}
```

```tsx
<Tabs
  items={[
    { key: 'tab1', label: '鱼类', children: <p>鲈鱼、鲷鱼...</p> },
    { key: 'tab2', label: '昆虫', children: <p>蝴蝶、蜻蜓...</p> },
  ]}
  defaultActiveKey="tab1"
/>

// Controlled mode
const [activeKey, setActiveKey] = useState('tab1');
<Tabs items={items} activeKey={activeKey} onChange={setActiveKey} />
```

---

#### Checkbox
Styled checkbox group with horizontal/vertical layout. Checked box fills with #19c8b9. Supports `string | number` values. No indeterminate state.

```ts
type CheckboxSize = 'small' | 'middle' | 'large';

interface CheckboxOption {
  label: React.ReactNode;
  value: string | number;
  disabled?: boolean;         // per-option disable
}

interface CheckboxProps {
  options: CheckboxOption[];                        // REQUIRED
  value?: Array<string | number>;                   // controlled
  defaultValue?: Array<string | number>;            // default []
  size?: CheckboxSize;                              // default 'middle'
  disabled?: boolean;                               // default false -- disables all
  direction?: 'horizontal' | 'vertical';            // default 'horizontal'
  onChange?: (values: Array<string | number>) => void;
  className?: string;
  style?: React.CSSProperties;
}
```

```tsx
<Checkbox
  options={[
    { label: '海滩', value: 'beach' },
    { label: '森林', value: 'forest' },
    { label: '螃蟹', value: 'crab', disabled: true },
  ]}
  defaultValue={['beach']}
/>

// Controlled + vertical with numeric values
<Checkbox
  options={[
    { label: 'Weekday', value: 1 },
    { label: 'Weekend', value: 2 },
  ]}
  value={values}
  onChange={setValues}
  direction="vertical"
  size="large"
/>
```

---

### Container (1)

#### Card
Themed content card with 13 NookPhone app-icon colors and 3 visual types.

```ts
type CardType  = 'default' | 'title' | 'dashed';

type CardColor =
  | 'default'          // rgb(247,243,223) / #725d42 text
  | 'app-pink'         // #f8a6b2 / #fff text
  | 'purple'           // #b77dee / #fff text
  | 'app-blue'         // #889df0 / #fff text
  | 'app-yellow'       // #f7cd67 / #725d42 text
  | 'app-orange'       // #e59266 / #fff text
  | 'app-teal'         // #82d5bb / #fff text
  | 'app-green'        // #8ac68a / #fff text
  | 'app-red'          // #fc736d / #fff text
  | 'lime-green'       // #d1da49 / #3d5a1a text
  | 'yellow-green'     // #ecdf52 / #725d42 text
  | 'brown'            // #9a835a / #fff text
  | 'warm-peach-pink'; // #e18c6f / #fff text

interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  type?: CardType;     // default 'default'
  color?: CardColor;   // default 'default'
  children?: React.ReactNode;
}
```

```tsx
<Card>Default parchment card</Card>
<Card type="title">Chapter One</Card>
<Card type="dashed">Draft / empty-state container</Card>
<Card color="app-yellow">Notification</Card>
```

---

### Decorative (5)

#### Time
Self-contained HUD widget showing weekday, date, and live clock. Auto-updates every second.

```ts
interface TimeProps {
  className?: string;
}
```

```tsx
<Time />   // auto-updates every second, shows weekday + date + clock
```

---

#### Phone
Decorative NookPhone widget. Fixed 527x788px, 3x3 app grid, live AM/PM clock with blinking colon, hover icon bounce.

```ts
interface PhoneProps {
  className?: string;
}
```

```tsx
<Phone />
```

---

#### Footer
Decorative footer illustration. Two types: forest silhouette (60px tall, default) or ocean wave (80px tall).

```ts
type FooterType = 'sea' | 'tree';

interface FooterProps {
  type?: FooterType;          // default 'tree'
  className?: string;
  style?: React.CSSProperties;
}
```

```tsx
<Footer />              {/* forest silhouette, 60px tall */}
<Footer type="sea" />   {/* ocean wave, 80px tall */}
```

---

#### Divider
Decorative horizontal divider band. 5 illustrated line types, fixed 12px height.

```ts
type DividerType = 'line-brown' | 'line-teal' | 'line-white' | 'line-yellow' | 'wave-yellow';

interface DividerProps {
  type?: DividerType;         // default 'line-brown'
  className?: string;
  style?: React.CSSProperties;
}
```

```tsx
<Divider />
<Divider type="wave-yellow" />
```

---

#### Icon
NookPhone app icon rendered as `<span>` with background-image SVG. 10 built-in icons with optional bounce animation.

```ts
type IconName =
  | 'icon-miles' | 'icon-camera' | 'icon-chat' | 'icon-critterpedia'
  | 'icon-design' | 'icon-diy'    | 'icon-helicopter'
  | 'icon-map'   | 'icon-shopping' | 'icon-variant';

interface IconProps {
  name: IconName;                // REQUIRED
  size?: number | string;        // default 24 (number=px, string=any CSS length)
  className?: string;
  style?: React.CSSProperties;
  bounce?: boolean;              // default false -- adds hover bounce animation
}

// Runtime catalogue for dynamic rendering / pickers (10 entries):
declare const ICON_LIST: { name: IconName; label: string }[];
```

```tsx
<Icon name="icon-camera" size={32} />
<Icon name="icon-chat" bounce />
{ICON_LIST.map(({ name, label }) => <Icon key={name} name={name} />)}
```

---

### Effect (3)

#### Cursor
Applies the custom game-style finger cursor to all descendants. Do not nest multiple Cursors.

```ts
interface CursorProps {
  children?: React.ReactNode;
  className?: string;
  style?: React.CSSProperties;
}
```

```tsx
<Cursor>
  <App />
</Cursor>
```

---

#### Typewriter
Typewriter animation that recursively truncates ReactNode by character count while preserving element structure. Renders NO wrapper element -- zero layout impact.

```ts
interface TypewriterProps {
  children?: React.ReactNode;   // ANY ReactNode -- preserves element structure, classNames, inline styles
  speed?: number;                // ms per char, default 90
  trigger?: unknown;             // change this value to restart animation (e.g. modal openCount)
  autoPlay?: boolean;            // default true (false = show full immediately)
  onDone?: () => void;
}
```

```tsx
<Typewriter speed={60} onDone={() => setStep(2)}>
  <p>Hello, <strong>traveler</strong>.</p>
  <p>Welcome to the island.</p>
</Typewriter>

// Restart on modal open:
<Typewriter trigger={openCount}>{dialogueText}</Typewriter>
```

---

#### CodeBlock
Dark-themed code display with built-in JSX/TS tokenizer. No language prop -- always treated as JSX/TS.

```ts
interface CodeBlockProps {
  code: string;                // REQUIRED -- raw source string
  style?: React.CSSProperties; // merged on top of the dark preset
  className?: string;
}
```

```tsx
<CodeBlock code={`import { Button } from 'animal-island-ui';\n\n<Button type="primary">Go</Button>`} />

<CodeBlock
  code={src}
  style={{ borderRadius: 5, backgroundColor: '#242c46' }}
/>
```

---

#### Loading
Full-screen island illustration loader with animated SVG (fish, waves, trees, leaves) using GSAP motion paths. Circular mask transition when deactivating.

```ts
interface LoadingProps {
  className?: string;
  style?: React.CSSProperties;
  active?: boolean;            // default true -- false triggers fade-out animation
}
```

```tsx
<Loading />
<Loading active={isLoading} />
```

---

## Exports Summary

```ts
import {
  Button, Input, Switch, Modal, Card, Collapse,
  Cursor, Time, Phone, Footer, Divider, Typewriter,
  Icon, Select, Tabs, Checkbox, CodeBlock, Loading,
} from 'animal-island-ui';

import { ICON_LIST } from 'animal-island-ui';

import type {
  ButtonProps, ButtonType, ButtonSize,
  InputProps, InputSize,
  SwitchProps, SwitchSize,
  ModalProps,
  CardProps, CardType, CardColor,
  CollapseProps,
  CursorProps,
  TimeProps,
  PhoneProps,
  FooterProps, FooterType,
  DividerProps,
  TypewriterProps,
  IconProps, IconName,
  SelectProps, SelectOption,
  TabsProps, TabItem,
  CheckboxProps, CheckboxOption, CheckboxSize,
  CodeBlockProps,
  LoadingProps,
} from 'animal-island-ui';
```

## Hard Rules

1. **Import style once via JS**: `import 'animal-island-ui/style';` at app entry (JS import, NOT CSS @import). Do not re-import per component.
2. **Do NOT invent props.** Every prop used must appear verbatim above. No `variant`, `shape`, `rounded`, `theme`, `color="primary"` etc. unless listed.
3. **`Modal.open` is required**; always provide a matching `onClose`.
4. **`Collapse.question` and `Collapse.answer` are required.**
5. **Button `type`** values are `primary | default | dashed | text | link` -- NOT `secondary`, `outline`, `ghost`. Use `ghost` prop for ghost styling.
6. **Switch `size`** is `'small' | 'default'` (NOT `'middle' | 'large'`). Diverges from Button/Input sizing.
7. **Card `color`** must be one of the 13 listed `CardColor` values. Do not pass hex codes.
8. **Typewriter emits no wrapper element.** Style the children, not the component.
9. **Icon `name`** must be one of the 10 `IconName` values -- no arbitrary strings, URLs, or React nodes.
10. **Select is controlled-only.** `options`, `value`, `onChange` are ALL required.
11. **CodeBlock** only highlights JSX/TS -- no `language` prop. Not intended for non-JS languages.
12. **Never use `style={{ borderRadius: 0 }}`** or force sharp corners on interactive elements.
13. **Never override the 3D bottom shadow** on Button/Input/Switch -- it is the core identity of the library.
14. **Do NOT import from deep paths** -- only the package root and `animal-island-ui/style` are public. The package.json `exports` field blocks all other paths.
