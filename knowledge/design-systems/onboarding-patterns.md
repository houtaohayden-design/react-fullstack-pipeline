# Onboarding Design — Premium User Onboarding Flows

First impressions as product design. Welcome screens, product tours, coach marks, progress tracking, and progressive disclosure patterns.

---

## 1. Onboarding Pattern Decision Matrix

| Pattern | Best For | Complexity | User Effort |
|---------|----------|-----------|-------------|
| **Welcome Screen** | Brand introduction, value prop | Low | Very low |
| **Feature Tour** | Highlighting 3-5 key features | Medium | Low |
| **Coach Marks** | Pointing to specific UI elements | Medium | Low |
| **Interactive Walkthrough** | Teaching complex workflows | High | Medium |
| **Progressive Setup** | Collecting profile/preferences | Medium | Medium |
| **Empty State Prompts** | Contextual guidance | Low | Very low |
| **Checklist** | Driving activation milestones | Low | Medium |
| **Video / Demo** | Complex product overview | Medium | Very low |

---

## 2. Welcome Screen Sequence

```tsx
function WelcomeScreen({ onComplete }: { onComplete: () => void }) {
  const [step, setStep] = useState(0);

  const screens = [
    {
      emoji: '🥗',
      title: 'Discover Healthy Recipes',
      description: 'Thousands of nutritious recipes tailored to your taste and health goals.',
      image: '/onboarding/step-1.webp',
    },
    {
      emoji: '📅',
      title: 'Plan Your Meals',
      description: 'Weekly meal plans that fit your schedule and dietary preferences.',
      image: '/onboarding/step-2.webp',
    },
    {
      emoji: '📊',
      title: 'Track Your Nutrition',
      description: 'Monitor calories, macros, and micronutrients effortlessly.',
      image: '/onboarding/step-3.webp',
    },
  ];

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-[--page-gutter] bg-background">
      {/* Content */}
      <div className="flex-1 flex flex-col items-center justify-center max-w-md text-center">
        <AnimatePresence mode="wait">
          <motion.div
            key={step}
            initial={{ opacity: 0, x: 50 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -50 }}
            transition={{ duration: 0.3 }}
          >
            <div className="text-6xl mb-6">{screens[step].emoji}</div>
            <h1 className="text-3xl font-bold mb-3">{screens[step].title}</h1>
            <p className="text-muted">{screens[step].description}</p>
            <img src={screens[step].image} alt="" className="mt-8 rounded-2xl shadow-xl" />
          </motion.div>
        </AnimatePresence>
      </div>

      {/* Footer */}
      <div className="w-full max-w-md py-8 space-y-4">
        {/* Dots */}
        <div className="flex justify-center gap-2">
          {screens.map((_, i) => (
            <button
              key={i}
              onClick={() => setStep(i)}
              className={`h-2 rounded-full transition-all duration-300 ${
                i === step ? 'w-8 bg-primary' : 'w-2 bg-muted/20'
              }`}
              aria-label={`Go to step ${i + 1}`}
            />
          ))}
        </div>

        {/* Actions */}
        <div className="flex gap-3">
          {step < screens.length - 1 ? (
            <>
              <button onClick={onComplete} className="btn-ghost flex-1">Skip</button>
              <button onClick={() => setStep(s => s + 1)} className="btn-primary flex-1">Continue</button>
            </>
          ) : (
            <button onClick={onComplete} className="btn-primary w-full">Get Started</button>
          )}
        </div>
      </div>
    </div>
  );
}
```

---

## 3. Feature Tour (Spotlight / Coach Marks)

```tsx
function FeatureTour({ steps, onComplete }: {
  steps: { target: string; title: string; description: string; position: 'top' | 'bottom' | 'left' | 'right' }[];
  onComplete: () => void;
}) {
  const [current, setCurrent] = useState(0);
  const [targetRect, setTargetRect] = useState<DOMRect | null>(null);

  useEffect(() => {
    const el = document.querySelector(steps[current].target);
    if (el) setTargetRect(el.getBoundingClientRect());
  }, [current]);

  const next = () => {
    if (current < steps.length - 1) setCurrent(c => c + 1);
    else onComplete();
  };

  if (!targetRect) return null;

  return (
    <div className="fixed inset-0 z-[200]">
      {/* Semi-transparent overlay with spotlight cutout */}
      <svg className="absolute inset-0 w-full h-full" viewBox={`0 0 ${window.innerWidth} ${window.innerHeight}`}>
        <defs>
          <mask id="spotlight">
            <rect width="100%" height="100%" fill="white" />
            <rect
              x={targetRect.x - 8} y={targetRect.y - 8}
              width={targetRect.width + 16} height={targetRect.height + 16}
              rx="8"
              fill="black"
            />
          </mask>
        </defs>
        <rect width="100%" height="100%" fill="rgba(0,0,0,0.6)" mask="url(#spotlight)" />
        {/* Spotlight border glow */}
        <rect
          x={targetRect.x - 8} y={targetRect.y - 8}
          width={targetRect.width + 16} height={targetRect.height + 16}
          rx="8"
          fill="none"
          stroke="var(--color-primary)"
          strokeWidth="2"
          mask="url(#spotlight)"
        />
      </svg>

      {/* Tooltip card */}
      <motion.div
        key={current}
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="absolute bg-surface border rounded-xl shadow-2xl p-5 max-w-xs"
        style={{
          left: targetRect.x + targetRect.width / 2,
          top: targetRect.y + targetRect.height + 12,
          transform: 'translateX(-50%)',
        }}
      >
        <p className="text-xs text-muted mb-1">{current + 1} of {steps.length}</p>
        <h3 className="text-sm font-semibold mb-1">{steps[current].title}</h3>
        <p className="text-xs text-muted mb-4">{steps[current].description}</p>
        <div className="flex items-center justify-between">
          <button onClick={onComplete} className="text-xs text-muted hover:text-foreground">Skip all</button>
          <button onClick={next} className="btn-primary btn-xs">
            {current < steps.length - 1 ? 'Next' : 'Done'}
          </button>
        </div>
      </motion.div>
    </div>
  );
}
```

---

## 4. Progress Checklist (Activation Milestones)

```tsx
function OnboardingChecklist() {
  const [tasks, setTasks] = useState([
    { id: 'profile', label: 'Complete your health profile', done: false },
    { id: 'recipe', label: 'Save your first recipe', done: false },
    { id: 'mealplan', label: 'Create a meal plan', done: false },
    { id: 'shop', label: 'Generate a shopping list', done: false },
    { id: 'track', label: 'Track a day of nutrition', done: false },
  ]);

  const completed = tasks.filter(t => t.done).length;
  const allDone = completed === tasks.length;

  return (
    <div className="bg-surface border rounded-xl p-5">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-sm font-semibold">Getting Started</h3>
        <span className="text-xs text-muted tabular-nums">{completed}/{tasks.length}</span>
      </div>

      {/* Overall progress */}
      <div className="h-1.5 bg-muted/10 rounded-full mb-4 overflow-hidden">
        <motion.div
          className="h-full bg-primary rounded-full"
          animate={{ width: `${(completed / tasks.length) * 100}%` }}
          transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
        />
      </div>

      {/* Task list */}
      <div className="space-y-1">
        {tasks.map(task => (
          <div
            key={task.id}
            className={`flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors ${
              task.done ? 'text-muted' : 'hover:bg-muted/5'
            }`}
          >
            <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 transition-colors ${
              task.done ? 'bg-success border-success' : 'border-muted/20'
            }`}>
              {task.done && <Check size={12} className="text-white" />}
            </div>
            <span className={`text-sm flex-1 ${task.done ? 'line-through' : ''}`}>
              {task.label}
            </span>
            {!task.done && (
              <span className="text-xs text-primary font-medium">Start →</span>
            )}
          </div>
        ))}
      </div>

      {allDone && (
        <motion.div
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: 'auto' }}
          className="mt-4 p-3 bg-success/5 border border-success/20 rounded-lg text-center"
        >
          <p className="text-sm text-success font-medium">You're all set!</p>
        </motion.div>
      )}
    </div>
  );
}
```

---

## 5. Contextual Empty State Prompts

These were covered in detail in `empty-states-design.md`. Key onboarding integration:

```tsx
function ContextualPrompt({ feature, onDismiss }: { feature: string; onDismiss: () => void }) {
  return (
    <motion.div
      initial={{ opacity: 0, height: 0 }}
      animate={{ opacity: 1, height: 'auto' }}
      exit={{ opacity: 0, height: 0 }}
      className="bg-primary/5 border border-primary/20 rounded-xl p-4 mb-4 relative"
    >
      <button onClick={onDismiss} className="absolute top-2 right-2 p-1 text-muted hover:text-foreground" aria-label="Dismiss">
        <X size={14} />
      </button>
      <div className="flex items-start gap-3">
        <Lightbulb size={18} className="text-primary shrink-0 mt-0.5" />
        <div>
          <p className="text-sm font-medium">Try {feature}</p>
          <p className="text-xs text-muted mt-0.5">
            Discover how {feature} can help you eat healthier.
          </p>
        </div>
      </div>
    </motion.div>
  );
}
```

---

## 6. Role / Preference Selection

```tsx
function PreferencePicker({
  options,
  selected,
  onChange,
  multiple = true,
}: {
  options: { id: string; label: string; icon: string; description: string }[];
  selected: string[];
  onChange: (ids: string[]) => void;
  multiple?: boolean;
}) {
  const toggle = (id: string) => {
    if (multiple) {
      onChange(selected.includes(id) ? selected.filter(s => s !== id) : [...selected, id]);
    } else {
      onChange([id]);
    }
  };

  return (
    <div className="grid grid-cols-2 gap-3">
      {options.map(option => {
        const isSelected = selected.includes(option.id);
        return (
          <button
            key={option.id}
            onClick={() => toggle(option.id)}
            className={`
              p-4 rounded-xl border-2 text-left transition-all duration-200
              ${isSelected
                ? 'border-primary bg-primary/5 shadow-sm'
                : 'border-border hover:border-muted/40 hover:bg-muted/5'
              }
            `}
          >
            <span className="text-2xl">{option.icon}</span>
            <h4 className="text-sm font-semibold mt-2">{option.label}</h4>
            <p className="text-xs text-muted mt-0.5">{option.description}</p>
          </button>
        );
      })}
    </div>
  );
}
```

---

## 7. Onboarding Flow Architecture

```tsx
function OnboardingFlow() {
  const [stage, setStage] = useState<'welcome' | 'preferences' | 'profile' | 'tour' | 'done'>('welcome');

  const stages = {
    welcome: <WelcomeScreen onComplete={() => setStage('preferences')} />,
    preferences: <PreferenceStep onComplete={() => setStage('profile')} />,
    profile: <ProfileStep onComplete={() => setStage('tour')} />,
    tour: <FeatureTour steps={featureTourSteps} onComplete={() => setStage('done')} />,
    done: <Redirect to="/dashboard" />,
  };

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={stage}
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 0.3 }}
      >
        {stages[stage]}
      </motion.div>
    </AnimatePresence>
  );
}
```

---

## 8. Onboarding Metrics (What to Track)

```
✓ Completion rate: % of users who finish onboarding
✓ Drop-off per step: which step loses the most users
✓ Time to complete: are users rushing or struggling?
✓ Skip rate: % who skip the tour (indicates value mismatch)
✓ Activation rate: % who complete key action within 24h
✓ Return rate: % who come back within 7 days

Good onboarding:
  - 70%+ completion rate
  - < 30% skip rate
  - < 3 min to complete
  - 50%+ activation rate
```

---

## 9. Onboarding Anti-Patterns

```
❌ Forced tour before any product access (let people explore)
❌ More than 5 steps in a tour (attention drops after 3)
❌ No skip button (always provide escape)
❌ Coach marks that cover important UI (show, then get out of the way)
❌ Asking for preferences before showing value (value first, data second)
❌ All-or-nothing onboarding (save partial progress)
❌ One-size-fits-all flow (power users vs. beginners need different paths)
❌ Tour on every new feature release (use a "What's new" badge instead)
```
