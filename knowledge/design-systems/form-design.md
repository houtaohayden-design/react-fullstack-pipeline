# Form Design — Premium Input Patterns & Validation

Forms as a conversation, not an interrogation. Input anatomy, validation states, multi-step flows, and accessibility patterns for premium UI.

---

## 1. Input Anatomy System

```
┌─────────────────────────────────────────┐
│  LABEL (required *)          HELPER TEXT │  ← Label row
│  ┌─────────────────────────────────┐    │
│  │ icon  [input value........]  btn │    │  ← Input container
│  └─────────────────────────────────┘    │
│  ERROR MESSAGE (visible on error only)   │  ← Error row
└─────────────────────────────────────────┘
```

### CSS Custom Properties
```css
:root {
  /* Input dimensions */
  --input-height-sm: 36px;
  --input-height-md: 44px;
  --input-height-lg: 52px;

  /* Radii */
  --input-radius-sm: 6px;
  --input-radius-md: 8px;
  --input-radius-lg: 12px;
  --input-radius-pill: 9999px;

  /* Colors */
  --input-bg: var(--color-surface);
  --input-border: var(--color-border);
  --input-border-focus: var(--color-primary);
  --input-text: var(--color-foreground);
  --input-placeholder: var(--color-muted);
  --input-error: var(--color-error);
  --input-success: var(--color-success);

  /* Transitions */
  --input-transition: 150ms var(--ease-out);
}
```

---

## 2. Input Style Variants

### Outlined (default, most common)
```css
.input-outlined {
  border: 1.5px solid var(--input-border);
  background: transparent;
  border-radius: var(--input-radius-md);
  transition: border-color var(--input-transition), box-shadow var(--input-transition);
}
.input-outlined:focus {
  border-color: var(--input-border-focus);
  box-shadow: 0 0 0 3px rgba(var(--primary-rgb), 0.15);
  outline: none;
}
.input-outlined[aria-invalid="true"] {
  border-color: var(--input-error);
  box-shadow: 0 0 0 3px rgba(var(--error-rgb), 0.15);
}
```

### Filled (subtle, material-like)
```css
.input-filled {
  border: none;
  border-bottom: 2px solid var(--input-border);
  background: rgba(var(--foreground-rgb), 0.04);
  border-radius: var(--input-radius-sm) var(--input-radius-sm) 0 0;
  transition: border-color var(--input-transition), background var(--input-transition);
}
.input-filled:focus {
  border-bottom-color: var(--input-border-focus);
  background: rgba(var(--primary-rgb), 0.04);
  outline: none;
}
```

### Underlined (minimal, editorial)
```css
.input-underlined {
  border: none;
  border-bottom: 1.5px solid var(--input-border);
  border-radius: 0;
  background: transparent;
  padding-inline: 0;
  transition: border-color var(--input-transition), border-width var(--input-transition);
}
.input-underlined:focus {
  border-bottom: 2px solid var(--input-border-focus);
  outline: none;
}
```

### Pill (search, newsletter, CTA forms)
```css
.input-pill {
  border: 1.5px solid var(--input-border);
  border-radius: var(--input-radius-pill);
  background: var(--input-bg);
  padding-inline: 20px;
}
```

---

## 3. Validation States

### The 5 Input States
```css
/* 1. IDLE — default, neutral */
.input { border-color: var(--color-border); }

/* 2. FOCUS — active, inviting */
.input:focus { border-color: var(--color-primary); box-shadow: 0 0 0 3px rgba(var(--primary-rgb), 0.15); }

/* 3. VALID — confirmation (show only after user interaction) */
.input[aria-invalid="false"][data-touched="true"] { border-color: var(--color-success); }

/* 4. INVALID — needs attention */
.input[aria-invalid="true"] { border-color: var(--color-error); }

/* 5. DISABLED — unavailable */
.input:disabled { opacity: 0.5; cursor: not-allowed; background: rgba(var(--foreground-rgb), 0.03); }
```

### Validation Timing (Critical UX)
```
When to show errors:
  ❌ on focus — aggressive, punishing
  ❌ on every keystroke — distracting
  ✅ on blur (after first interaction) — gentle guidance
  ✅ on submit — authoritative validation
  ✅ after fix (clear error on change) — rewarding
```

### Inline Validation Component
```tsx
interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string;
  helperText?: string;
  error?: string;
  hint?: string;
}

function Input({ label, helperText, error, hint, id, ...props }: InputProps) {
  const [touched, setTouched] = useState(false);

  return (
    <div className="input-group">
      <div className="flex items-center justify-between mb-1.5">
        <label htmlFor={id} className="text-sm font-medium text-foreground">
          {label}
          {props.required && <span className="text-error ml-0.5">*</span>}
        </label>
        {helperText && (
          <span className="text-xs text-muted">{helperText}</span>
        )}
      </div>

      <input
        id={id}
        aria-invalid={touched && !!error ? 'true' : undefined}
        aria-describedby={error ? `${id}-error` : hint ? `${id}-hint` : undefined}
        data-touched={touched}
        onBlur={() => setTouched(true)}
        onChange={() => { if (error) setTouched(false); }}
        className={`input-outlined h-[44px] w-full px-3 text-sm
          ${touched && error ? 'border-error' : ''}
        `}
        {...props}
      />

      {hint && !error && (
        <p id={`${id}-hint`} className="mt-1.5 text-xs text-muted">{hint}</p>
      )}
      {error && touched && (
        <p id={`${id}-error`} role="alert" className="mt-1.5 text-xs text-error flex items-center gap-1">
          <AlertCircle size={12} />
          {error}
        </p>
      )}
    </div>
  );
}
```

---

## 4. Form Layout Patterns

### Single Column (standard, all-purpose)
```css
.form-stack {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-width: 480px;
}
```
Best for: login, signup, settings, checkout

### Two Column (compact, side-by-side fields)
```css
.form-grid-2 {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}
@media (max-width: 640px) {
  .form-grid-2 { grid-template-columns: 1fr; }
}
```
Best for: first/last name, start/end date, city/zip

### Inline (search, subscribe, CTA)
```css
.form-inline {
  display: flex;
  gap: 8px;
  align-items: flex-end; /* aligns button with input bottom */
}
.form-inline input { flex: 1; }
.form-inline button { flex-shrink: 0; }
```
Best for: search bars, newsletter signups, promo codes

### Floating Label (space-saving, material style)
```tsx
function FloatingInput({ label, id, ...props }: InputProps) {
  return (
    <div className="relative">
      <input
        id={id}
        placeholder={label} /* visible label via placeholder */
        className="input-outlined h-[52px] w-full px-4 pt-4 pb-1 text-sm peer"
        {...props}
      />
      <label
        htmlFor={id}
        className="absolute left-4 top-1 text-[10px] text-muted
          peer-placeholder-shown:top-4 peer-placeholder-shown:text-sm
          transition-all duration-200 pointer-events-none"
      >
        {label}
      </label>
    </div>
  );
}
```

---

## 5. Multi-Step Form / Wizard

```tsx
interface Step {
  title: string;
  fields: React.ReactNode;
  validate: () => boolean;
}

function MultiStepForm({ steps }: { steps: Step[] }) {
  const [step, setStep] = useState(0);
  const [direction, setDirection] = useState<1 | -1>(1);
  const isLast = step === steps.length - 1;
  const isFirst = step === 0;

  const next = () => {
    if (steps[step].validate()) {
      setDirection(1);
      setStep(s => Math.min(s + 1, steps.length - 1));
    }
  };

  const prev = () => {
    setDirection(-1);
    setStep(s => Math.max(s - 1, 0));
  };

  return (
    <div className="max-w-lg mx-auto">
      {/* Progress Bar */}
      <nav aria-label="Form progress" className="mb-8">
        <div className="flex gap-2 mb-3">
          {steps.map((s, i) => (
            <div
              key={i}
              className={`h-1.5 flex-1 rounded-full transition-all duration-300
                ${i <= step ? 'bg-primary scale-100' : 'bg-muted/20'}
              `}
            />
          ))}
        </div>
        <p className="text-xs text-muted text-center">
          Step {step + 1} of {steps.length}: {steps[step].title}
        </p>
      </nav>

      {/* Step Content with Directional Animation */}
      <AnimatePresence mode="wait" custom={direction}>
        <motion.div
          key={step}
          custom={direction}
          initial={{ opacity: 0, x: direction * 30 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: direction * -30 }}
          transition={{ duration: 0.2, ease: [0, 0, 0.2, 1] }}
        >
          {steps[step].fields}
        </motion.div>
      </AnimatePresence>

      {/* Navigation */}
      <div className="flex justify-between mt-8 pt-6 border-t">
        {isFirst ? <div /> : (
          <button type="button" onClick={prev} className="btn-ghost">
            ← Back
          </button>
        )}
        <button type="button" onClick={next} className="btn-primary">
          {isLast ? 'Complete' : 'Continue →'}
        </button>
      </div>
    </div>
  );
}
```

---

## 6. Specialized Input Components

### Password Input with Strength Meter
```tsx
function PasswordInput({ onChange }: { onChange: (v: string) => void }) {
  const [value, setValue] = useState('');
  const [visible, setVisible] = useState(false);

  const strength = (() => {
    let score = 0;
    if (value.length >= 8) score++;
    if (/[A-Z]/.test(value)) score++;
    if (/[0-9]/.test(value)) score++;
    if (/[^A-Za-z0-9]/.test(value)) score++;
    return score;
  })();

  const labels = ['Weak', 'Fair', 'Good', 'Strong'];
  const colors = ['#ef4444', '#f97316', '#eab308', '#22c55e'];

  return (
    <div>
      <div className="relative">
        <input
          type={visible ? 'text' : 'password'}
          value={value}
          onChange={e => { setValue(e.target.value); onChange(e.target.value); }}
          className="input-outlined h-[44px] w-full px-3 pr-10"
          aria-describedby="password-strength"
        />
        <button
          type="button"
          onClick={() => setVisible(!visible)}
          className="absolute right-3 top-1/2 -translate-y-1/2 text-muted hover:text-foreground"
          aria-label={visible ? 'Hide password' : 'Show password'}
        >
          {visible ? <EyeOff size={16} /> : <Eye size={16} />}
        </button>
      </div>
      {value.length > 0 && (
        <div id="password-strength" className="mt-2">
          <div className="flex gap-1">
            {[0, 1, 2, 3].map(i => (
              <div key={i} className={`h-1 flex-1 rounded-full transition-colors duration-300
                ${i < strength ? '' : 'bg-muted/20'}
              `} style={{ backgroundColor: i < strength ? colors[strength - 1] : undefined }} />
            ))}
          </div>
          <p className="text-xs mt-1" style={{ color: colors[strength - 1] || colors[0] }}>
            {labels[strength - 1] || 'Too short'}
          </p>
        </div>
      )}
    </div>
  );
}
```

### OTP / Code Input
```tsx
function OTPInput({ length = 6, onComplete }: { length?: number; onComplete: (code: string) => void }) {
  const [values, setValues] = useState<string[]>(Array(length).fill(''));
  const refs = useRef<(HTMLInputElement | null)[]>([]);

  const handleChange = (index: number, value: string) => {
    if (!/^\d*$/.test(value)) return;
    const next = [...values];
    next[index] = value.slice(-1);
    setValues(next);

    if (value && index < length - 1) refs.current[index + 1]?.focus();
    if (next.every(v => v.length === 1)) onComplete(next.join(''));
  };

  const handleKeyDown = (index: number, e: React.KeyboardEvent) => {
    if (e.key === 'Backspace' && !values[index] && index > 0) {
      refs.current[index - 1]?.focus();
    }
  };

  return (
    <div className="flex gap-2 justify-center">
      {values.map((v, i) => (
        <input
          key={i}
          ref={el => refs.current[i] = el}
          value={v}
          onChange={e => handleChange(i, e.target.value)}
          onKeyDown={e => handleKeyDown(i, e)}
          className="input-outlined w-12 h-14 text-center text-lg font-bold"
          maxLength={1}
          aria-label={`Digit ${i + 1}`}
        />
      ))}
    </div>
  );
}
```

### Search with Autocomplete
```tsx
function SearchInput() {
  const [query, setQuery] = useState('');
  const [open, setOpen] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  return (
    <div className="relative" ref={ref}>
      <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted" />
      <input
        ref={inputRef}
        value={query}
        onChange={e => { setQuery(e.target.value); setOpen(true); }}
        onFocus={() => setOpen(true)}
        onKeyDown={e => {
          if (e.key === 'Escape') { setOpen(false); inputRef.current?.blur(); }
        }}
        placeholder="Search..."
        className="input-pill h-[44px] w-full pl-10 pr-4 text-sm"
        role="combobox"
        aria-expanded={open}
        aria-autocomplete="list"
      />
      {query && (
        <button
          onClick={() => { setQuery(''); setOpen(false); inputRef.current?.focus(); }}
          className="absolute right-3 top-1/2 -translate-y-1/2 text-muted hover:text-foreground"
          aria-label="Clear search"
        >
          <X size={16} />
        </button>
      )}

      {open && query && (
        <div className="absolute top-full mt-2 w-full bg-surface border rounded-lg shadow-lg p-2 z-50" role="listbox">
          <div className="text-xs text-muted px-3 py-2">Start typing to search...</div>
        </div>
      )}
    </div>
  );
}
```

---

## 7. Form-Level Features

### Auto-Save (debounced)
```tsx
function AutoSaveForm() {
  const { register, watch, formState } = useForm();
  const [saveStatus, setSaveStatus] = useState<'saved' | 'saving' | 'unsaved'>('saved');

  const watchedData = watch();

  useEffect(() => {
    if (!formState.isDirty) return;
    setSaveStatus('unsaved');

    const timer = setTimeout(async () => {
      setSaveStatus('saving');
      await saveToAPI(watchedData);
      setSaveStatus('saved');
    }, 1000); // 1s debounce

    return () => clearTimeout(timer);
  }, [watchedData]);

  return (
    <form>
      {/* fields */}
      <div className="fixed bottom-4 right-4 flex items-center gap-2 text-xs">
        {saveStatus === 'saving' && <Spinner size={12} />}
        <span className={saveStatus === 'saved' ? 'text-success' : 'text-muted'}>
          {saveStatus === 'saved' ? '✓ Saved' : saveStatus === 'saving' ? 'Saving...' : 'Unsaved'}
        </span>
      </div>
    </form>
  );
}
```

### Submit States
```tsx
function SubmitButton({
  loading,
  success,
  error,
  children,
}: {
  loading: boolean;
  success: boolean;
  error?: string;
  children: React.ReactNode;
}) {
  return (
    <div>
      <button
        type="submit"
        disabled={loading || success}
        className={`btn-primary relative overflow-hidden transition-all duration-300
          ${loading ? 'pr-12' : ''}
          ${success ? 'bg-success border-success' : ''}
        `}
      >
        {children}
        {loading && <Spinner size={16} className="absolute right-3 top-1/2 -translate-y-1/2" />}
      </button>

      {/* Success animation */}
      <AnimatePresence>
        {success && (
          <motion.p
            initial={{ opacity: 0, y: 4 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-xs text-success mt-2 flex items-center gap-1"
          >
            <CheckCircle size={12} /> Submitted successfully
          </motion.p>
        )}
      </AnimatePresence>

      {error && (
        <p role="alert" className="text-xs text-error mt-2 flex items-center gap-1">
          <AlertCircle size={12} /> {error}
        </p>
      )}
    </div>
  );
}
```

---

## 8. Form Accessibility Checklist

```
✓ Every input has an associated <label> (htmlFor matching id)
✓ Required fields marked with both * and aria-required="true"
✓ Errors use role="alert" for screen reader announcement
✓ Error inputs use aria-invalid="true"
✓ Helper text linked via aria-describedby="<id>-hint"
✓ Focus ring visible at 3:1 contrast minimum
✓ Keyboard navigation works (Tab, Shift+Tab)
✓ No auto-advancing (WCAG 2.2 Focus Not Obscured)
✓ Touch targets ≥ 44px (WCAG 2.5.5)
✓ Form has accessible name (aria-label or <legend>)
```

---

## 9. Form Layout Decision Tree

```
How many fields?
  ≤ 3   → Single column or inline
  4-8   → Single column (standard) or two-column grid
  9+    → Single column or grouped sections with <fieldset>

What type of form?
  Login/signup   → Single column, max-width 400px, centered
  Settings       → Grouped sections, single column, max-width 600px
  Checkout       → Two columns (inputs left, summary right)
  Onboarding     → Multi-step wizard with progress
  Search         → Inline, auto-complete dropdown
  Feedback       → Single textarea + inline submit, minimal

Complexity?
  Simple         → Single column stack
  Complex        → Grouped <fieldset> sections with legends
  Very complex   → Multi-step wizard or accordion sections
```

---

## 10. Complete Form Example (Login)

```tsx
function LoginForm() {
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm({
    resolver: zodResolver(z.object({
      email: z.string().email('Valid email required'),
      password: z.string().min(8, 'Minimum 8 characters'),
    })),
  });
  const [serverError, setServerError] = useState('');

  const onSubmit = async (data: any) => {
    setServerError('');
    try {
      await loginAPI(data);
      // redirect
    } catch (e: any) {
      setServerError(e.message || 'Login failed. Please try again.');
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="form-stack mx-auto max-w-md">
      <div className="text-center mb-6">
        <h1 className="text-2xl font-bold">Welcome back</h1>
        <p className="text-muted text-sm mt-1">Enter your credentials to continue</p>
      </div>

      {serverError && (
        <div role="alert" className="bg-error/5 border border-error/20 rounded-lg p-3 text-sm text-error flex items-center gap-2">
          <AlertCircle size={16} />
          {serverError}
        </div>
      )}

      <Input
        label="Email"
        type="email"
        id="email"
        placeholder="you@example.com"
        autoComplete="email"
        error={errors.email?.message}
        {...register('email')}
      />

      <Input
        label="Password"
        type="password"
        id="password"
        placeholder="••••••••"
        autoComplete="current-password"
        error={errors.password?.message}
        {...register('password')}
      />

      <div className="flex items-center justify-between">
        <label className="flex items-center gap-2 text-sm cursor-pointer">
          <input type="checkbox" className="rounded accent-primary" />
          Remember me
        </label>
        <a href="/forgot-password" className="text-sm text-primary hover:underline">Forgot password?</a>
      </div>

      <SubmitButton loading={isSubmitting} success={false}>
        Sign In
      </SubmitButton>

      <p className="text-center text-sm text-muted">
        Don't have an account? <a href="/register" className="text-primary hover:underline">Sign up</a>
      </p>
    </form>
  );
}
```
