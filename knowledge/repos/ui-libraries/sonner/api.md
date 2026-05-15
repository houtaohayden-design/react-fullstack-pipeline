# Sonner — API Reference

> Opinionated toast notification library for React. Minimal, customizable, with built-in Promise support.

## Setup

```bash
npm install sonner
```

## Basic Usage

```tsx
import { Toaster, toast } from 'sonner';

function App() {
  return (
    <>
      <Toaster />
      <button onClick={() => toast('Hello!')}>Show toast</button>
    </>
  );
}
```

---

## Toaster Component

The `Toaster` component renders the toast container. Place it once in your app root.

### Toaster Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| **position** | `'top-left'` \| `'top-right'` \| `'bottom-left'` \| `'bottom-right'` \| `'top-center'` \| `'bottom-center'` | `'bottom-right'` | Toast container position |
| **expand** | `boolean` | `false` | Whether toasts expand by default |
| **visibleToasts** | `number` | `3` | Number of visible toasts at once |
| **closeButton** | `boolean` | `false` | Show a close button on all toasts |
| **richColors** | `boolean` | `false` | Use colorful styling based on toast type |
| **theme** | `'light'` \| `'dark'` \| `'system'` | `'light'` | Theme mode |
| **duration** | `number` | `4000` | Default toast duration in ms |
| **gap** | `number` | `14` | Gap between toasts in px |
| **offset** | `string` \| `number` \| `{ top?, right?, bottom?, left? }` | `'24px'` | Viewport offset |
| **mobileOffset** | `string` \| `number` \| `{ top?, right?, bottom?, left? }` | `'16px'` | Mobile viewport offset |
| **hotkey** | `string[]` | `['altKey', 'KeyT']` | Keyboard shortcut to focus toasts |
| **toastOptions** | `ToastOptions` | — | Default options applied to all toasts |
| **invert** | `boolean` | `false` | Invert toast stacking (useful in bottom positions) |
| **dir** | `'rtl'` \| `'ltr'` \| `'auto'` | `'auto'` | Text direction |
| **icons** | `ToastIcons` | — | Custom icon overrides per type |
| **swipeDirections** | `SwipeDirection[]` | Auto from position | Allowed swipe directions |
| **className** | `string` | — | CSS class for the toast container |
| **style** | `React.CSSProperties` | — | Inline style for the container |
| **closeButtonAriaLabel** | `string` | `'Close toast'` | ARIA label for close button |
| **containerAriaLabel** | `string` | `'Notifications'` | ARIA label for the container |

---

## toast() Function

The main `toast` function is an object combining the base function with type-specific methods.

### toast(message, options?)

```tsx
// Basic message
toast('Event has been created');

// With options
toast('Event has been created', {
  description: 'Monday, January 3rd at 6:00pm',
  action: { label: 'Undo', onClick: () => console.log('Undo') },
  duration: 5000,
});
```

### toast Types

| Method | Description |
|--------|-------------|
| **toast(message, options?)** | Default/normal toast |
| **toast.success(message, options?)** | Success-styled toast |
| **toast.error(message, options?)** | Error-styled toast |
| **toast.info(message, options?)** | Info-styled toast |
| **toast.warning(message, options?)** | Warning-styled toast |
| **toast.loading(message, options?)** | Loading spinner toast (persistent until dismissed) |
| **toast.message(message, options?)** | Same as default toast |
| **toast.custom(jsx, options?)** | Custom JSX toast |
| **toast.promise(promise, data)** | Promise-based toast with loading/success/error states |
| **toast.dismiss(id?)** | Dismiss a specific toast (or all if no id) |

### Toast Options (ExternalToast)

| Option | Type | Description |
|--------|------|-------------|
| **id** | `string \| number` | Custom toast ID (auto-generated if omitted) |
| **icon** | `React.ReactNode` | Custom icon |
| **description** | `React.ReactNode \| (() => React.ReactNode)` | Description text below title |
| **duration** | `number` | Override default duration (ms). `Infinity` for persistent |
| **closeButton** | `boolean` | Override show close button |
| **dismissible** | `boolean` | Whether the toast can be dismissed by user (default: `true`) |
| **action** | `Action \| React.ReactNode` | Action button: `{ label, onClick }` |
| **cancel** | `Action \| React.ReactNode` | Cancel/secondary button |
| **invert** | `boolean` | Invert this specific toast's stacking |
| **position** | `Position` | Override position for this toast |
| **unstyled** | `boolean` | Remove default styling |
| **richColors** | `boolean` | Enable rich colors for this toast |
| **className** | `string` | CSS class on toast element |
| **descriptionClassName** | `string` | CSS class on description element |
| **style** | `React.CSSProperties` | Inline styles on toast element |
| **actionButtonStyle** | `React.CSSProperties` | Styles on action button |
| **cancelButtonStyle** | `React.CSSProperties` | Styles on cancel button |
| **classNames** | `ToastClassnames` | Per-part class names |
| **onDismiss** | `(toast: ToastT) => void` | Callback when toast is dismissed |
| **onAutoClose** | `(toast: ToastT) => void` | Callback when toast auto-closes |
| **importnt** | `boolean` | Whether toast is important for screen readers |

---

## toast.promise()

The most powerful feature — handles async operations with automatic state transitions:

```tsx
const promise = () => new Promise((resolve) => setTimeout(resolve, 2000));

toast.promise(promise, {
  loading: 'Loading...',
  success: (data) => `Successfully loaded ${data.name}`,
  error: 'Error occurred',
});
```

### Promise Data Options

```tsx
toast.promise<ResponseType>(promise, {
  loading: 'Saving...',                    // Shown while promise is pending
  success: (data) => 'Saved!',             // Shown on resolve
  error: (err) => 'Failed to save',        // Shown on reject
  description: (data) => data.message,     // Dynamic description (loading/success/error)
  finally: () => console.log('Done!'),     // Runs after settle
  duration: 3000,                          // Duration for success/error states
});
```

The promise toast transitions automatically: `loading` -> `success` or `error`.

---

## Toast ClassNames

| Key | Description |
|-----|-------------|
| `toast` | Toast wrapper element |
| `title` | Title text element |
| `description` | Description text element |
| `loader` | Loading spinner |
| `closeButton` | Close button |
| `cancelButton` | Cancel button |
| `actionButton` | Action button |
| `content` | Content wrapper |
| `icon` | Icon container |
| `default` | Default toast type |
| `success` | Success toast type |
| `error` | Error toast type |
| `info` | Info toast type |
| `warning` | Warning toast type |
| `loading` | Loading toast type |

---

## Toast Icons

```tsx
<Toaster
  icons={{
    success: <CheckCircleIcon />,
    error: <XCircleIcon />,
    info: <InfoIcon />,
    warning: <WarningIcon />,
    loading: <Spinner />,
    close: <XIcon />,
  }}
/>
```

---

## Multiple Toasters

Use `toasterId` to target specific Toaster instances:

```tsx
// In app root
<Toaster id="main" position="bottom-right" />
<Toaster id="sidebar" position="top-right" />

// Usage
toast('Main notification', { toasterId: 'main' });
toast('Sidebar event', { toasterId: 'sidebar' });
```

---

## useSonner() Hook

Access toast list programmatically:

```tsx
import { useSonner } from 'sonner';

function ToastList() {
  const { toasts } = useSonner();
  return toasts.map(t => <div key={t.id}>{t.title}</div>);
}
```
