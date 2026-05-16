# Landing Page Architecture — Premium Section Patterns

Complete catalog of landing page section patterns. Mix and match to compose any premium marketing page.

---

## 1. Hero Section Patterns

### Hero A: Centered Statement
```tsx
function HeroCentered() {
  return (
    <section className="min-h-screen flex items-center justify-center px-6 relative overflow-hidden">
      {/* Background decoration */}
      <div className="absolute inset-0 bg-gradient-to-b from-primary/5 to-transparent" />
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 w-[800px] h-[800px]
        rounded-full bg-primary/5 blur-3xl" />

      <div className="relative z-10 text-center max-w-3xl">
        <span className="eyebrow mb-4">Discover Your Perfect Meal</span>
        <h1 className="text-5xl md:text-7xl font-bold tracking-tight leading-none mb-6">
          Eat Well,{" "}
          <span className="gradient-text from-primary to-accent">Live Better</span>
        </h1>
        <p className="text-xl text-muted-foreground max-w-xl mx-auto mb-10">
          Personalized meal plans crafted by nutrition experts. Every recipe calibrated for your health goals.
        </p>
        <div className="flex gap-4 justify-center">
          <button className="btn-press px-8 py-4 bg-primary text-primary-foreground rounded-xl font-semibold text-lg
            hover:shadow-lg transition-shadow">
            Get Started Free
          </button>
          <button className="btn-press px-8 py-4 border rounded-xl font-semibold text-lg hover:bg-muted transition-colors">
            View Recipes →
          </button>
        </div>

        {/* Trust badges */}
        <div className="flex items-center justify-center gap-8 mt-12 text-sm text-muted-foreground">
          <span className="flex items-center gap-2">★ 4.9/5 Rating</span>
          <span className="flex items-center gap-2">✓ 10k+ Recipes</span>
          <span className="flex items-center gap-2">🔒 HIPAA Secure</span>
        </div>
      </div>
    </section>
  );
}
```

### Hero B: Split (Image + Text)
```tsx
function HeroSplit() {
  return (
    <section className="min-h-screen grid grid-cols-1 lg:grid-cols-2">
      {/* Image side */}
      <div className="relative h-64 lg:h-full order-2 lg:order-1">
        <img src="/hero-food.jpg" alt="Healthy food"
          className="absolute inset-0 w-full h-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-r from-black/20 to-transparent" />
      </div>

      {/* Text side */}
      <div className="flex items-center px-8 lg:px-20 py-16 order-1 lg:order-2">
        <div className="max-w-lg">
          <h1 className="text-5xl font-bold leading-tight mb-6">
            Nutrition Science Meets Culinary Art
          </h1>
          <p className="text-lg text-muted-foreground mb-8">
            Every recipe backed by research, every meal a masterpiece.
          </p>
          <div className="flex gap-3">
            <input placeholder="Your email" className="input-glow px-4 py-3 rounded-xl border bg-background flex-1" />
            <button className="btn-press px-6 py-3 bg-primary text-primary-foreground rounded-xl font-semibold">
              Start Free Trial
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
```

### Hero C: Full-Bleed Media
```tsx
function HeroMedia() {
  return (
    <section className="relative min-h-screen flex items-center justify-center">
      {/* Background video */}
      <video autoPlay muted loop playsInline className="absolute inset-0 w-full h-full object-cover">
        <source src="/cooking-bg.mp4" type="video/mp4" />
      </video>
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" />

      <div className="relative z-10 text-center text-white max-w-4xl px-6">
        <motion.h1
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: [0.22, 1, 0.36, 1] }}
          className="text-6xl md:text-8xl font-black tracking-tight mb-6"
        >
          The Art of<br />Healthy Living
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.2, ease: [0.22, 1, 0.36, 1] }}
          className="text-xl text-white/70 max-w-2xl mx-auto mb-10"
        >
          Immersive culinary experiences designed for your wellbeing
        </motion.p>
      </div>

      {/* Scroll indicator */}
      <motion.div
        animate={{ y: [0, 8, 0] }}
        transition={{ duration: 2, repeat: Infinity }}
        className="absolute bottom-8 left-1/2 -translate-x-1/2"
      >
        <div className="w-6 h-10 rounded-full border-2 border-white/30 flex justify-center pt-2">
          <div className="w-1 h-2 rounded-full bg-white/60" />
        </div>
      </motion.div>
    </section>
  );
}
```

### Hero D: Search-First
```tsx
function HeroSearch() {
  return (
    <section className="min-h-[80vh] flex items-center justify-center px-6"
      style={{ background: 'linear-gradient(180deg, #faf7f2 0%, #f0ebe0 100%)' }}>
      <div className="max-w-2xl w-full text-center">
        <h1 className="text-5xl font-bold mb-4">What do you want to cook?</h1>
        <p className="text-lg text-muted-foreground mb-8">Search 10,000+ healthy recipes</p>

        <div className="flex gap-2 p-2 bg-white rounded-2xl shadow-lg border">
          <input
            placeholder="Try 'Mediterranean bowl' or 'low-carb dinner'..."
            className="flex-1 px-4 py-4 bg-transparent outline-none text-lg"
          />
          <button className="px-8 py-4 bg-primary text-primary-foreground rounded-xl font-semibold
            hover:scale-105 active:scale-95 transition-transform">
            Search
          </button>
        </div>

        <div className="flex gap-3 justify-center mt-6 text-sm text-muted-foreground">
          <span>Popular:</span>
          {['Keto', 'Mediterranean', 'Vegan', 'High Protein', '30min'].map(tag => (
            <button key={tag} className="px-3 py-1 rounded-full bg-white border hover:border-primary hover:text-primary transition-colors">
              {tag}
            </button>
          ))}
        </div>
      </div>
    </section>
  );
}
```

---

## 2. Feature Sections

### Features: 3-Column Grid
```tsx
function FeatureGrid({ features }: { features: Feature[] }) {
  return (
    <section className="py-24 px-6 max-w-6xl mx-auto">
      <div className="text-center mb-16">
        <span className="eyebrow">Why Choose Us</span>
        <h2 className="text-4xl font-bold mt-2 mb-4">Everything you need to eat healthier</h2>
        <p className="text-muted-foreground max-w-xl mx-auto">
          From meal planning to grocery shopping, we've got you covered.
        </p>
      </div>

      <div className="grid md:grid-cols-3 gap-8">
        {features.map((f, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: i * 0.1 }}
            className="p-8 rounded-2xl bg-card border hover:shadow-lg transition-shadow duration-300 group"
          >
            <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center mb-4
              group-hover:bg-primary group-hover:text-primary-foreground transition-colors">
              {f.icon}
            </div>
            <h3 className="text-xl font-semibold mb-2">{f.title}</h3>
            <p className="text-muted-foreground">{f.description}</p>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
```

### Features: Alternating Rows
```tsx
function FeatureAlternating({ features }: { features: Feature[] }) {
  return (
    <section className="py-24 px-6 max-w-6xl mx-auto space-y-32">
      {features.map((f, i) => (
        <motion.div
          key={i}
          initial={{ opacity: 0, y: 40 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className={`grid md:grid-cols-2 gap-12 items-center ${
            i % 2 === 1 ? 'md:[direction:rtl]' : ''
          }`}
        >
          <div className={i % 2 === 1 ? '[direction:ltr]' : ''}>
            <div className="rounded-2xl overflow-hidden shadow-lg">
              <img src={f.image} alt={f.title} className="w-full aspect-[4/3] object-cover" />
            </div>
          </div>
          <div className={i % 2 === 1 ? '[direction:ltr]' : ''}>
            <span className="eyebrow">{f.eyebrow}</span>
            <h3 className="text-3xl font-bold mt-2 mb-4">{f.title}</h3>
            <p className="text-muted-foreground text-lg leading-relaxed mb-6">{f.description}</p>
            <ul className="space-y-3">
              {f.bullets?.map((b, j) => (
                <li key={j} className="flex items-start gap-3">
                  <CheckCircle className="w-5 h-5 text-primary mt-0.5 shrink-0" />
                  <span>{b}</span>
                </li>
              ))}
            </ul>
          </div>
        </motion.div>
      ))}
    </section>
  );
}
```

---

## 3. Stats / Social Proof

### Stats Bar
```tsx
function StatsBar({ stats }: { stats: { value: string; label: string }[] }) {
  return (
    <section className="py-16 bg-primary/5">
      <div className="max-w-5xl mx-auto px-6 grid grid-cols-2 md:grid-cols-4 gap-8">
        {stats.map((stat, i) => (
          <div key={i} className="text-center">
            <div className="text-3xl md:text-4xl font-bold tracking-tight mb-1">{stat.value}</div>
            <div className="text-sm text-muted-foreground">{stat.label}</div>
          </div>
        ))}
      </div>
    </section>
  );
}
```

### Testimonial Cards
```tsx
function Testimonials({ reviews }: { reviews: Review[] }) {
  return (
    <section className="py-24 px-6 max-w-6xl mx-auto">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold mb-4">Loved by home cooks everywhere</h2>
      </div>

      <div className="grid md:grid-cols-3 gap-6">
        {reviews.map((r, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: i * 0.1 }}
            className="p-8 rounded-2xl bg-card border"
          >
            {/* Stars */}
            <div className="flex gap-1 mb-4 text-yellow-400">
              {Array.from({ length: 5 }).map((_, j) => (
                <Star key={j} className={`w-4 h-4 ${j < r.rating ? 'fill-current' : 'text-muted/20'}`} />
              ))}
            </div>

            <blockquote className="text-lg leading-relaxed mb-6">
              &ldquo;{r.text}&rdquo;
            </blockquote>

            <div className="flex items-center gap-3">
              <img src={r.avatar} alt={r.name} className="w-10 h-10 rounded-full object-cover" />
              <div>
                <div className="font-semibold text-sm">{r.name}</div>
                <div className="text-xs text-muted-foreground">{r.role}</div>
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
```

### Logo Cloud
```tsx
function LogoCloud({ logos }: { logos: string[] }) {
  return (
    <section className="py-16 border-y">
      <div className="max-w-5xl mx-auto px-6">
        <p className="text-center text-sm text-muted-foreground mb-8">
          Featured in leading food & health publications
        </p>
        <div className="flex flex-wrap items-center justify-center gap-12 opacity-40 grayscale hover:grayscale-0 transition-all duration-500">
          {logos.map((logo, i) => (
            <img key={i} src={logo} alt="" className="h-8 object-contain" />
          ))}
        </div>
      </div>
    </section>
  );
}
```

---

## 4. Pricing Section

### Pricing: 3-Tier Cards
```tsx
function PricingCards({ plans }: { plans: Plan[] }) {
  return (
    <section className="py-24 px-6 max-w-5xl mx-auto">
      <div className="text-center mb-16">
        <span className="eyebrow">Pricing</span>
        <h2 className="text-4xl font-bold mt-2 mb-4">Choose your plan</h2>
      </div>

      <div className="grid md:grid-cols-3 gap-6 items-start">
        {plans.map((plan, i) => (
          <div key={i} className={cn(
            'p-8 rounded-2xl border-2 transition-shadow duration-300',
            plan.featured
              ? 'border-primary shadow-xl shadow-primary/10 relative scale-105'
              : 'hover:shadow-lg'
          )}>
            {plan.featured && (
              <div className="absolute -top-3 left-1/2 -translate-x-1/2 px-4 py-1 bg-primary text-primary-foreground text-xs font-bold rounded-full">
                Most Popular
              </div>
            )}

            <h3 className="text-xl font-semibold mb-2">{plan.name}</h3>
            <div className="mb-6">
              <span className="text-4xl font-bold">${plan.price}</span>
              <span className="text-muted-foreground">/month</span>
            </div>

            <ul className="space-y-3 mb-8">
              {plan.features.map((f, j) => (
                <li key={j} className="flex items-center gap-2 text-sm">
                  <CheckIcon className="w-4 h-4 text-primary shrink-0" />
                  {f}
                </li>
              ))}
            </ul>

            <button className={cn(
              'w-full py-3 rounded-xl font-semibold transition-all active:scale-95',
              plan.featured
                ? 'bg-primary text-primary-foreground hover:shadow-lg'
                : 'border-2 hover:bg-muted'
            )}>
              {plan.featured ? 'Start Free Trial' : 'Get Started'}
            </button>
          </div>
        ))}
      </div>
    </section>
  );
}
```

---

## 5. CTA Patterns

### CTA: Simple Banner
```tsx
function CTABanner() {
  return (
    <section className="py-24 px-6">
      <div className="max-w-3xl mx-auto text-center bg-primary rounded-3xl p-12 md:p-16 text-primary-foreground relative overflow-hidden">
        {/* Decoration */}
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full translate-y-1/2 -translate-x-1/2" />

        <div className="relative z-10">
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            Ready to transform your eating habits?
          </h2>
          <p className="text-primary-foreground/70 text-lg mb-8 max-w-md mx-auto">
            Join 50,000+ people who've already discovered the joy of healthy eating.
          </p>
          <div className="flex gap-3 justify-center">
            <button className="px-8 py-4 bg-white text-primary rounded-xl font-semibold
              hover:scale-105 active:scale-95 transition-transform">
              Get Started Free
            </button>
            <button className="px-8 py-4 border border-white/20 rounded-xl font-semibold
              hover:bg-white/10 transition-colors">
              Talk to Sales
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
```

---

## 6. FAQ Accordion

```tsx
function FAQ({ items }: { items: { q: string; a: string }[] }) {
  const [openIndex, setOpenIndex] = useState<number | null>(null);

  return (
    <section className="py-24 px-6 max-w-2xl mx-auto">
      <h2 className="text-3xl font-bold text-center mb-12">Frequently Asked Questions</h2>

      <div className="space-y-3">
        {items.map((item, i) => (
          <div key={i} className="rounded-xl border overflow-hidden">
            <button
              onClick={() => setOpenIndex(openIndex === i ? null : i)}
              className="w-full px-6 py-4 flex items-center justify-between text-left hover:bg-muted/50 transition-colors"
            >
              <span className="font-medium">{item.q}</span>
              <motion.span
                animate={{ rotate: openIndex === i ? 45 : 0 }}
                transition={{ duration: 0.2 }}
                className="text-muted-foreground text-xl"
              >
                +
              </motion.span>
            </button>

            <AnimatePresence>
              {openIndex === i && (
                <motion.div
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: 'auto', opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={{ duration: 0.3, ease: [0.22, 1, 0.36, 1] }}
                >
                  <div className="px-6 pb-4 text-muted-foreground leading-relaxed">
                    {item.a}
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        ))}
      </div>
    </section>
  );
}
```

---

## 7. Footer Patterns

### Premium Footer
```tsx
function PremiumFooter() {
  return (
    <footer className="bg-card border-t">
      <div className="max-w-6xl mx-auto px-6 py-16">
        <div className="grid md:grid-cols-5 gap-8 mb-12">
          {/* Brand column */}
          <div className="md:col-span-2">
            <h3 className="text-2xl font-bold mb-4">HealthyRecipes</h3>
            <p className="text-muted-foreground max-w-xs leading-relaxed">
              Your personal nutrition companion. Discover, plan, and cook healthy meals every day.
            </p>
            <div className="flex gap-3 mt-6">
              {['twitter', 'instagram', 'youtube', 'pinterest'].map(social => (
                <a key={social} href="#" className="w-10 h-10 rounded-lg border flex items-center justify-center
                  text-muted-foreground hover:text-primary hover:border-primary transition-colors">
                  {/* icon */}
                </a>
              ))}
            </div>
          </div>

          {/* Link columns */}
          {[
            { title: 'Product', links: ['Features', 'Pricing', 'Recipes', 'Meal Plans'] },
            { title: 'Company', links: ['About', 'Blog', 'Careers', 'Press'] },
            { title: 'Support', links: ['Help Center', 'Contact', 'Privacy', 'Terms'] },
          ].map((col, i) => (
            <div key={i}>
              <h4 className="font-semibold text-sm mb-4">{col.title}</h4>
              <ul className="space-y-3">
                {col.links.map(link => (
                  <li key={link}>
                    <a href="#" className="text-sm text-muted-foreground hover:text-foreground transition-colors">
                      {link}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="pt-8 border-t flex flex-col sm:flex-row justify-between items-center gap-4 text-sm text-muted-foreground">
          <span>&copy; 2026 HealthyRecipes. All rights reserved.</span>
          <div className="flex gap-6">
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Cookie Policy</a>
          </div>
        </div>
      </div>
    </footer>
  );
}
```

---

## 8. How It Works (Steps)

```tsx
function HowItWorks({ steps }: { steps: Step[] }) {
  return (
    <section className="py-24 px-6 max-w-4xl mx-auto">
      <h2 className="text-3xl font-bold text-center mb-16">How it works</h2>

      <div className="relative">
        {/* Connecting line */}
        <div className="absolute left-8 top-0 bottom-0 w-px bg-border hidden md:block" />

        <div className="space-y-12">
          {steps.map((step, i) => (
            <motion.div
              key={i}
              initial={{ opacity: 0, x: -20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.15 }}
              className="flex gap-6 items-start"
            >
              {/* Step number */}
              <div className="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center shrink-0 relative z-10">
                <span className="text-primary font-bold text-xl">{i + 1}</span>
              </div>

              <div className="pt-1">
                <h3 className="text-xl font-semibold mb-2">{step.title}</h3>
                <p className="text-muted-foreground leading-relaxed">{step.description}</p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
```

---

## Quick Assembly Guide

```
Landing page composition (top to bottom):
  1. Nav (sticky)
  2. Hero (A/B/C/D — pick one)
  3. Logo Cloud (social proof)
  4. Features Grid or Alternating
  5. Stats Bar
  6. How It Works (steps)
  7. Testimonials
  8. Pricing
  9. FAQ
  10. CTA Banner
  11. Footer
```
