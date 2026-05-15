# NextUI (HeroUI v3) — Patterns & Best Practices

## Architecture

HeroUI v3 is a modern React UI library built on:
- **Tailwind CSS v4** for styling
- **React Aria Components** for accessibility
- **tailwind-variants** for variant system
- **framer-motion** for animations

### Package Structure
```
@nextui-org/react     — Main package (all components)
@heroui/styles        — Shared CSS styles with BEM naming
@heroui/react         — Alternative import path
```

## Styling System

### Tailwind CSS v4 Native

HeroUI is fully Tailwind-native. Components render with Tailwind utility classes. Customization is done via:

1. **Variant props** — Use built-in variants for consistent look
2. **className override** — Pass custom Tailwind classes
3. **Tailwind theme extension** — Extend colors, spacing, etc. in your Tailwind config

### BEM Class Naming Convention

HeroUI v3 uses BEM (Block Element Modifier) for CSS classes:
- **Block**: Component class (e.g., `button`, `card`, `alert`)
- **Modifier**: Variation using double dashes (e.g., `button--solid`, `button--lg`, `button--icon-only`)
- **Element**: Child element using double underscores (e.g., `card__header`, `alert__icon`)

### Default Size Pattern

All components include default sizes in their base classes:
```css
.button {
  @apply h-10 md:h-9 px-4;  /* Default size = md */
}
.button--sm { @apply h-8 px-3 text-sm; }
.button--md { /* No styles — this is the default */ }
.button--lg { @apply h-11 px-6 text-lg; }
```

This ensures components work without explicit size classes.

### Variant System with tailwind-variants

```typescript
import { tv } from "tailwind-variants";

const buttonVariants = tv({
  base: "inline-flex items-center justify-center rounded-lg font-medium",
  variants: {
    variant: {
      solid: "bg-primary text-white hover:bg-primary-600",
      bordered: "border-2 border-primary text-primary",
      light: "bg-primary/10 text-primary",
    },
    size: {
      sm: "h-8 px-3 text-sm",
      md: "h-10 px-4",
      lg: "h-11 px-6 text-lg",
    },
    fullWidth: { true: "w-full" },
    isIconOnly: { true: "px-0" },
  },
  defaultVariants: { variant: "solid", size: "md" },
});
```

### composeTwRenderProps

Utility to merge Tailwind classes with React Aria render props:
```typescript
import { composeTwRenderProps } from "../../utils";

<ButtonPrimitive
  className={composeTwRenderProps(className, styles)}
/>
```

## Component Pattern

### Compound Component Pattern

HeroUI uses a Radix UI-inspired compound component pattern:

```tsx
// Accordion example
<Accordion.Root>
  <Accordion.Item value="item-1">
    <Accordion.Heading>
      <Accordion.Trigger>
        Section 1
        <Accordion.Indicator />
      </Accordion.Trigger>
    </Accordion.Heading>
    <Accordion.Panel>
      <Accordion.Body>Content</Accordion.Body>
    </Accordion.Panel>
  </Accordion.Item>
</Accordion.Root>

// Alert example
<Alert.Root>
  <Alert.Icon />
  <Alert.Title>Success</Alert.Title>
  <Alert.Description>Operation completed.</Alert.Description>
  <Alert.Action>Undo</Alert.Action>
  <Alert.Close />
</Alert.Root>
```

### Composition with Shared Components

HeroUI reuses shared primitives rather than creating component-specific variants:
```tsx
// Checkbox uses external Label/Description
<div className="flex items-center gap-3">
  <Checkbox.Root value="terms"><Checkbox.Indicator /></Checkbox.Root>
  <Label htmlFor="terms">Accept terms</Label>
</div>

// TextField uses slots for form composition
<TextField.Root>
  <TextField.Label>Email</TextField.Label>
  <TextField.Input placeholder="you@example.com" />
  <TextField.Description>We'll never share your email.</TextField.Description>
  <TextField.ErrorMessage />
</TextField.Root>
```

## Accessibility

### Built on React Aria

All components built on React Aria Components primitives:
- ARIA attributes automatically managed
- Keyboard navigation (Tab, Arrow keys, Enter, Escape)
- Screen reader support
- Focus management (focus trapping in modals)
- Press, hover, focus states via React Aria hooks

### Interactive State Attributes

Components use both pseudo-classes AND data-attributes for interactive states:
```css
.button {
  &:hover, &[data-hovered="true"] { @apply bg-primary-600; }
  &:active, &[data-pressed="true"] { @apply bg-primary-700; }
  &:focus-visible, &[data-focus-visible="true"] { outline: 2px solid var(--focus); }
}
```

## Dark Mode

HeroUI has built-in dark mode support via Tailwind CSS v4:
```tsx
// Uses Tailwind's dark mode class strategy
<NextUIProvider>
  <html className="dark">  {/* or "light" */}
    <App />
  </html>
</NextUIProvider>
```

Components automatically adapt to dark mode through CSS variables and Tailwind's `dark:` modifier.

## Responsive Design

Works with Tailwind breakpoints natively:
```tsx
<TextField className="w-full sm:w-80 md:w-96" />
<Tabs className="max-w-full md:max-w-2xl" />
```

Components can be composed with responsive Tailwind utilities directly.

## Form Patterns

### Controlled Form
```tsx
function LoginForm() {
  const [email, setEmail] = useState('');

  return (
    <Form onSubmit={(e) => { e.preventDefault(); console.log({ email }); }}>
      <div className="flex flex-col gap-4">
        <TextField.Root>
          <TextField.Label>Email</TextField.Label>
          <TextField.Input value={email} onChange={(e) => setEmail(e.target.value)} />
          <TextField.ErrorMessage />
        </TextField.Root>
        <Button type="submit" fullWidth>Sign In</Button>
      </div>
    </Form>
  );
}
```

### Fieldset Pattern
```tsx
<Fieldset.Root>
  <Fieldset.Legend>Profile Information</Fieldset.Legend>
  <Fieldset.FieldGroup>
    <Fieldset.Field>
      <TextField.Root>
        <TextField.Label>Name</TextField.Label>
        <TextField.Input />
      </TextField.Root>
    </Fieldset.Field>
    <Fieldset.Field>
      <TextField.Root>
        <TextField.Label>Email</TextField.Label>
        <TextField.Input type="email" />
      </TextField.Root>
    </Fieldset.Field>
  </Fieldset.FieldGroup>
</Fieldset.Root>
```

## Modal Patterns

```tsx
function DeleteDialog() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      <Button variant="danger" onPress={() => setIsOpen(true)}>Delete</Button>
      <AlertDialog.Root isOpen={isOpen} onOpenChange={setIsOpen}>
        <AlertDialog.Overlay />
        <AlertDialog.Content>
          <AlertDialog.Header>
            <AlertDialog.Title>Delete Item</AlertDialog.Title>
            <AlertDialog.Description>This action cannot be undone.</AlertDialog.Description>
          </AlertDialog.Header>
          <AlertDialog.Footer>
            <AlertDialog.Cancel>Cancel</AlertDialog.Cancel>
            <AlertDialog.Action onPress={() => handleDelete()}>Delete</AlertDialog.Action>
          </AlertDialog.Footer>
        </AlertDialog.Content>
      </AlertDialog.Root>
    </>
  );
}
```

## Toast Notifications

```tsx
import { useToast } from '@nextui-org/react';

function MyComponent() {
  const toast = useToast();

  const handleSave = () => {
    toast.addToast({ title: 'Saved', description: 'Changes saved successfully.', color: 'success' });
  };
}
```

## Menu Pattern

```tsx
<Menu.Root>
  <Menu.Trigger>
    <Button variant="bordered">Options</Button>
  </Menu.Trigger>
  <Menu.Content>
    <Menu.Item>Profile</Menu.Item>
    <Menu.Item>Settings</Menu.Item>
    <Menu.Separator />
    <Menu.Item>Logout</Menu.Item>
  </Menu.Content>
</Menu.Root>
```

## Popover Pattern

```tsx
<Popover.Root>
  <Popover.Trigger>
    <Button>Show Info</Button>
  </Popover.Trigger>
  <Popover.Content>
    <Popover.Header>
      <Popover.Title>Information</Popover.Title>
      <Popover.Description>Additional details here.</Popover.Description>
    </Popover.Header>
    <Popover.Body>Content body</Popover.Body>
    <Popover.Footer>
      <Button size="sm" variant="light">Close</Button>
    </Popover.Footer>
  </Popover.Content>
</Popover.Root>
```

## Best Practices

1. **Use compound components** — Compose sub-parts rather than monolithic props for maximum flexibility.
2. **className for Tailwind** — Override styles with Tailwind classes via `className`, not inline styles.
3. **Unstyled mode** — Use standard HTML behavior; components are accessible without any styles.
4. **Render props** — Use React Aria render props for dynamic rendering based on interaction state.
5. **BEM classes** — Use BEM modifiers for variant styling, not dynamic concatenation (Tailwind v4 requires complete class names).
6. **Default sizes** — Always include default sizes in base classes so components work without explicit size props.
7. **External Label/Description** — For checkbox, radio, switch — use shared Label and Description components, not component-specific ones.
8. **forwardRef** — All HeroUI components support ref forwarding.
9. **displayName** — All components have `HeroUI.ComponentName` display name format.

## Tailwind Compatibility

HeroUI IS Tailwind-native. It works seamlessly with Tailwind projects:
- Uses Tailwind CSS v4 utility classes internally
- Customizable via Tailwind theme extension
- className prop accepts any Tailwind utility classes
- BEM classes are compatible with Tailwind's class detection
- Dark mode via Tailwind's `dark:` variant
