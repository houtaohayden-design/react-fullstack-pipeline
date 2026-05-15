# Mantine — Patterns & Best Practices

## Architecture

Mantine v7+ is a React component library using CSS Modules (PostCSS) for styling, NOT Tailwind CSS. It ships its own CSS that you import once. The library is organized as a monorepo with multiple packages under `@mantine/*`.

### Key Packages
```
@mantine/core          — 96+ main components
@mantine/hooks         — 70+ utility hooks
@mantine/form          — Form state management
@mantine/dates         — Date pickers, calendars
@mantine/charts        — Recharts-based chart components
@mantine/notifications — Toast notification system
@mantine/modals        — Modal manager
@mantine/spotlight     — Command palette
@mantine/carousel      — Carousel (Embla-based)
@mantine/dropzone      — File drop zone
@mantine/tiptap        — Rich text editor
@mantine/nprogress     — Navigation progress bar
@mantine/code-highlight — Code syntax highlighting
```

## Styling System

### CSS Modules (default in v7)

Mantine uses CSS Modules with PostCSS. Every component has its own `.module.css` file. Styles are imported automatically when you import the CSS at the app root:

```tsx
// In your app entry point:
import '@mantine/core/styles.css';
import '@mantine/dates/styles.css';
// ... per-package CSS imports
```

### Style Props

Most components accept direct style props via `Box` base:
```tsx
<Paper bg="blue.1" c="blue.9" p="md" m="lg" radius="md" shadow="sm" />
// bg = background-color, c = color, p = padding, m = margin
```

### Polymorphism

Components extend `polymorphicFactory` — any component can be rendered as a different HTML element:
```tsx
<Button component="a" href="/home">Go Home</Button>
<Card component="article">Content</Card>
```

### Component Composition

Components are composed via `StylesApiProps` — shared API for styles customization:
```tsx
<Button
  classNames={{ root: 'my-root', inner: 'my-inner', label: 'my-label' }}
  styles={{ root: { '--button-bg': 'red' } }}
/>
```

### Custom CSS Variables

Many components expose CSS variables for deep customization:
```css
.my-button {
  --button-bg: var(--mantine-color-blue-6);
  --button-radius: var(--mantine-radius-xl);
}
```

## Theme System

### MantineProvider

```tsx
import { MantineProvider, createTheme, DEFAULT_THEME } from '@mantine/core';

const theme = createTheme({
  primaryColor: 'blue',
  primaryShade: 6,
  fontFamily: 'Inter, sans-serif',
  fontFamilyMonospace: 'JetBrains Mono, monospace',
  headings: { fontFamily: 'Inter, sans-serif' },
  colors: {
    // Custom color definitions (10 shades: 0-9)
    brand: ['#f0f5ff', '#d6e4ff', '#adc6ff', '#85a5ff', '#597ef7', '#2f54eb', '#1d39c4', '#10239e', '#061178', '#030852'],
  },
  defaultRadius: 'md',
  spacing: { xs: '0.25rem', sm: '0.5rem', md: '1rem', lg: '1.5rem', xl: '2rem' },
  breakpoints: { xs: '36em', sm: '48em', md: '62em', lg: '75em', xl: '88em' },
  components: {
    Button: {
      defaultProps: { variant: 'filled', size: 'md' },
      classNames: { root: 'custom-button' },
      styles: { root: { fontWeight: 600 } },
    },
  },
});

function App() {
  return <MantineProvider theme={theme}><App /></MantineProvider>;
}
```

### Color System

Mantine's color system uses 10 shades (0 = lightest, 9 = darkest) per color:
```tsx
<Button color="blue.5" />  // Specific shade
<Button color="blue" />     // Uses primaryShade (default 6)
```

### Dark Mode

```tsx
function App() {
  return (
    <MantineProvider defaultColorScheme="light">
      <YourApp />
    </MantineProvider>
  );
}

// Access color scheme:
import { useMantineColorScheme } from '@mantine/core';
const { colorScheme, setColorScheme } = useMantineColorScheme();
```

## Layout Patterns

### FlexStack/Group for Layout

Mantine's preferred layout pattern:
```tsx
// Horizontal
<Group gap="md" justify="space-between" align="center">{children}</Group>

// Vertical
<Stack gap="lg" align="stretch">{children}</Stack>

// Responsive grid
<SimpleGrid cols={{ base: 1, sm: 2, md: 3 }} spacing="lg">{children}</SimpleGrid>

// Flex
<Flex direction={{ base: 'column', sm: 'row' }} gap="md" align="center">{children}</Flex>
```

### AppShell for Page Layout

```tsx
<AppShell
  header={{ height: 60 }}
  navbar={{ width: 300, breakpoint: 'sm' }}
  padding="md"
>
  <AppShell.Header>Header content</AppShell.Header>
  <AppShell.Navbar>Navbar</AppShell.Navbar>
  <AppShell.Main>Main content</AppShell.Main>
</AppShell>
```

## Form Handling

### @mantine/form

```tsx
import { useForm } from '@mantine/form';

const form = useForm({
  mode: 'uncontrolled',     // or 'controlled'
  initialValues: { name: '', email: '', age: 18 },
  validate: {
    name: (value) => (value.length < 2 ? 'Too short' : null),
    email: (value) => (/^\S+@\S+$/.test(value) ? null : 'Invalid email'),
  },
  validateInputOnBlur: true,
  onValuesChange: (values) => console.log(values),
});

// Usage:
<TextInput {...form.getInputProps('name')} label="Name" />
<TextInput {...form.getInputProps('email')} label="Email" />
<NumberInput {...form.getInputProps('age')} label="Age" />
<Button onClick={() => form.onSubmit((values) => console.log(values))()}>Submit</Button>
```

### Form with validation schema (Zod/Yup)

```tsx
import { zodResolver } from 'mantine-form-zod-resolver';
import { z } from 'zod';

const schema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
});

const form = useForm({
  validate: zodResolver(schema),
  initialValues: { name: '', email: '' },
});
```

## Modal & Overlay Patterns

### Modal with Confirmation

```tsx
import { useDisclosure } from '@mantine/hooks';

function MyComponent() {
  const [opened, { open, close }] = useDisclosure(false);

  return (
    <>
      <Modal opened={opened} onClose={close} title="Confirm" centered size="md">
        <Stack gap="md">
          <Text>Are you sure you want to delete this item?</Text>
          <Group justify="flex-end">
            <Button variant="default" onClick={close}>Cancel</Button>
            <Button color="red" onClick={() => { handleDelete(); close(); }}>Delete</Button>
          </Group>
        </Stack>
      </Modal>
      <Button onClick={open} color="red">Delete</Button>
    </>
  );
}
```

### Notification Pattern

```tsx
import { notifications } from '@mantine/notifications';

const id = notifications.show({
  title: 'Processing',
  message: 'Your file is being uploaded...',
  loading: true,
  autoClose: false,
  withCloseButton: false,
});

// Later, on success:
notifications.update({
  id,
  color: 'teal',
  title: 'Done',
  message: 'Upload complete!',
  loading: false,
  autoClose: 3000,
});
```

## Data Fetching Integration

Mantine is backend-agnostic and pairs well with:
- **TanStack Query** for server state
- **SWR** for lightweight fetching
- **Zustand** for client state
- **@mantine/form** for form state

```tsx
// With TanStack Query:
import { useQuery } from '@tanstack/react-query';

function UsersPage() {
  const { data, isLoading, error } = useQuery({ queryKey: ['users'], queryFn: fetchUsers });

  if (isLoading) return <Skeleton height={200} />;
  if (error) return <Alert color="red">{error.message}</Alert>;

  return (
    <Table data={{ head: ['Name', 'Email'], body: data.map(u => [u.name, u.email]) }} />
  );
}
```

## Best Practices

1. **Import CSS per package** — Each @mantine/* package needs its own CSS import.
2. **Use style props over custom CSS** — `p="md"` / `bg="blue"` are more maintainable.
3. **Use useDisclosure for modals/popovers** — Standard pattern: `const [opened, { open, close }] = useDisclosure(false)`.
4. **uncontrolled mode for forms** — `mode: 'uncontrolled'` gives better performance for large forms.
5. **Theme provider at the top** — All Mantine components need MantineProvider ancestor.
6. **Polymorphic components** — Use `component` prop instead of wrapper elements.
7. **CSS Modules for custom styles** — Use `className` or `classNames` prop, not global CSS.
8. **Don't mix with Tailwind** — Mantine uses its own CSS system. Combining with Tailwind requires careful configuration (CSS layer ordering).

## Tailwind CSS Compatibility

Mantine v7 is NOT Tailwind-native. It uses CSS Modules with PostCSS. However, it CAN be used alongside Tailwind if you:

1. Configure PostCSS to process both Mantine's styles and Tailwind
2. Set up proper CSS layer ordering (Tailwind utilities should NOT override Mantine's specificity)
3. Use `unstyled` prop to strip Mantine styles and apply Tailwind classes: `<Button unstyled className="px-4 py-2 bg-blue-500 rounded" />`

Preferred approach: Use Mantine exclusively, OR use Tailwind with a Tailwind-native library (NextUI/HeroUI, shadcn/ui, daisyUI).

## Responsive Design

Mantine supports responsive style props with object syntax:
```tsx
<SimpleGrid cols={{ base: 1, sm: 2, lg: 3 }} />
<Text size={{ base: 'sm', md: 'md', lg: 'lg' }} />
<Container size={{ base: '100%', md: 'md', lg: 'lg' }} />
<Group visibleFrom="md" />  {/* Only visible from md and up */}
<Box hiddenFrom="sm" />     {/* Hidden from sm and up */}
```
