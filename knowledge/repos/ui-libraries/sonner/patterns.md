# Sonner — Patterns & Best Practices

## Architecture

Sonner is a minimal, opinionated toast notification library. It uses an **Observer pattern** internally — `ToastState` is a singleton that manages toast creation, updates, and dismissal. The `Toaster` component subscribes to state changes and renders the toast list.

### Key Design Decisions

1. **No external dependencies** — Pure React, no animation libraries (CSS transitions for all animations)
2. **CSS-based animations** — Toast enter/exit animations are pure CSS (no JS animation library)
3. **Swipe to dismiss** — Touch-friendly swipe gestures built-in
4. **Stacking** — Toasts stack with a visual 3D perspective effect
5. **Singleton state** — Toast state is shared globally via the `ToastState` observer

### File Structure
```
src/
  index.tsx      — Main component (Toaster, Toast, useSonner hooks)
  state.ts       — ToastState singleton (Observer pattern), toast() function
  types.ts       — TypeScript type definitions
  assets.tsx     — Default icons (Close, Loader, type icons)
  hooks.tsx      — useIsDocumentHidden hook
  styles.css     — All toast CSS styles
```

## Styling Approach

### CSS-Based (not Tailwind)

Sonner ships its own CSS. It is NOT Tailwind-native — it uses its own CSS classes and CSS custom properties for theming.

### Data Attributes

Sonner uses data attributes extensively for styling states:
```html
<li
  data-sonner-toast=""
  data-type="success"
  data-mounted="true"
  data-visible="true"
  data-front="true"
  data-rich-colors="false"
  data-styled="true"
  data-dismissible="true"
/>
```

### CSS Custom Properties

| Property | Description |
|----------|-------------|
| `--index` | Toast index in stack |
| `--offset` | Vertical offset from position |
| `--initial-height` | Height of first toast for stacking calculation |
| `--width` | Toast width (default: `356px`) |
| `--gap` | Gap between toasts |
| `--swipe-amount-x` | Horizontal swipe delta (px) |
| `--swipe-amount-y` | Vertical swipe delta (px) |
| `--front-toast-height` | Height of frontmost toast |
| `--offset-top/right/bottom/left` | Viewport margins |
| `--mobile-offset-top/right/bottom/left` | Mobile viewport margins |

### Rich Colors Mode

When `richColors` is enabled, Sonner applies color-coded backgrounds based on toast type:
- `success` — green tones
- `error` — red tones  
- `info` — blue tones
- `warning` — yellow/amber tones

This is controlled via the `data-rich-colors` attribute and CSS selectors.

### Unstyled Mode

Sonner supports unstyled rendering for custom styling with Tailwind or CSS-in-JS:
```tsx
// Per-toast unstyled
toast('Hello', { unstyled: true, className: 'bg-white shadow-lg rounded-lg p-4' });

// All toasts unstyled
<Toaster toastOptions={{ unstyled: true }} />
```

When `unstyled` is true, Sonner skips all default styles except positioning/layout. This makes it Tailwind-compatible.

## Theme System

Sonner supports three theme modes:
```tsx
<Toaster theme="light" />   // Force light
<Toaster theme="dark" />    // Force dark
<Toaster theme="system" />  // Follow OS preference
```

Theme is applied via `data-sonner-theme` attribute on the container `<ol>`. CSS selectors use this to apply light/dark styles. When `theme="system"`, the component listens to `prefers-color-scheme` media query changes.

## Animation System

Sonner uses CSS animations (not JS libraries):

1. **Enter animation**: Toast appears with scale + translate + opacity transition
2. **Exit animation**: Toast moves out with swipe direction + opacity fade
3. **Stack animation**: Toast stacking uses smooth CSS transitions on `--offset` and `--index`
4. **Height animation**: When a toast is removed, remaining toasts smoothly re-position

Key animation CSS classes/attributes:
- `[data-mounted="true"]` — Triggers enter animation
- `[data-removed="true"]` — Triggers exit animation
- `[data-swiping="true"]` — During drag/swipe
- `[data-swipe-out="true"]` — During swipe-out dismissal
- `[data-expanded="true"]` — When toast stack is expanded

## Toast Lifecycle

1. `toast('message')` called → `ToastState.create()` → publishes event
2. `Toaster` component receives event → adds toast to state array
3. Toast mounts → CSS enter animation plays
4. Toast timer starts (`duration` ms, defaults to 4000)
5. On hover/touch: timer pauses; expanded state reveals all toasts
6. On timer expiry or dismiss: `deleteToast()` → marks as `remove` → exit animation → unmount

## Promise Pattern

Sonner's `toast.promise()` is a powerful pattern for async operations:

```tsx
// Simple save operation
toast.promise(saveChanges(), {
  loading: 'Saving...',
  success: 'Saved successfully',
  error: 'Error saving',
});

// With dynamic content
const uploadPromise = uploadFile(file);
toast.promise(uploadPromise, {
  loading: 'Uploading file...',
  success: (result) => `Uploaded: ${result.filename}`,
  error: (err) => `Upload failed: ${err.message}`,
  description: (data) => `Size: ${formatBytes(data.size)}`,
  finally: () => refetchFiles(),
});

// Http response handling
toast.promise(fetch('/api/data'), {
  loading: 'Fetching...',
  success: 'Data loaded',
  error: 'Failed to load',
});
```

The promise toast automatically:
1. Shows loading state while promise is pending
2. Transitions to success state on resolve
3. Transitions to error state on reject
4. Handles HTTP Response objects (checks `response.ok`)
5. Calls `finally` callback after settle

## Dismissal Patterns

```tsx
// Dismiss specific toast by ID
const id = toast('Saving...');
toast.dismiss(id);

// Dismiss all toasts
toast.dismiss();

// Undo pattern
toast('Item deleted', {
  action: {
    label: 'Undo',
    onClick: () => restoreItem(),
  },
});

// Auto-close callback
toast('Processing...', {
  onAutoClose: () => console.log('Toast auto-closed'),
  onDismiss: () => console.log('Toast dismissed by user'),
});
```

## Best Practices

1. **Single Toaster** — Place one `<Toaster />` in your app root (unless using multiple toasterIds).
2. **Rich colors for important notifications** — Use `richColors` on the Toaster or per-toast for color-coded feedback.
3. **Use promise for async** — `toast.promise()` handles the loading/success/error lifecycle cleanly.
4. **Set duration per toast type** — Error toasts should persist longer; `duration: Infinity` for permanent.
5. **Action buttons for undo patterns** — Allow users to undo destructive actions.
6. **Custom JSX for complex content** — Use `toast.custom()` for rich, interactive toast content.
7. **Unstyled mode for Tailwind projects** — Sonner is NOT Tailwind-native by default. Use `unstyled: true` with custom classNames when using in Tailwind projects.

## Tailwind CSS Compatibility

Sonner is NOT Tailwind-native by default. It ships its own CSS. However, it can work with Tailwind:

```tsx
// Approach 1: Use unstyled + className
toast('Event created', {
  unstyled: true,
  className: 'bg-white dark:bg-gray-800 shadow-lg rounded-lg border border-gray-200 p-4',
  descriptionClassName: 'text-gray-600 text-sm',
});

// Approach 2: Override via classNames
<Toaster
  toastOptions={{
    classNames: {
      toast: 'group bg-white dark:bg-gray-800 shadow-lg rounded-lg',
      title: 'text-gray-900 dark:text-gray-100 font-medium',
      description: 'text-gray-500 text-sm',
      actionButton: 'bg-blue-500 text-white rounded px-3 py-1',
      cancelButton: 'bg-gray-200 text-gray-700 rounded px-3 py-1',
    },
  }}
/>
```

## Comparison with Other Toast Libraries

| Feature | Sonner | react-hot-toast | react-toastify |
|---------|--------|-----------------|----------------|
| Size (minzipped) | ~4.5KB | ~5KB | ~6KB |
| Promise support | Built-in | Built-in | Manual |
| Rich colors | Built-in | Built-in | Manual |
| Swipe to dismiss | Built-in | No | Built-in |
| Stacking effect | Yes | No | No |
| Multiple toasters | Yes | No | Yes (containers) |
| Tailwind compatibility | unstyled mode | unstyled mode | className |
| TypeScript | First-class | Good | Good |
