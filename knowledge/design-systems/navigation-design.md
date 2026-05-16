# Navigation Design — Premium Navigation Patterns

Navigation as wayfinding, not signposts. Mega menus, sidebars, command palettes, tabs, breadcrumbs, and mobile patterns for premium applications.

---

## 1. Navigation Type Decision Matrix

| Type | Best For | Complexity | Mobile Strategy |
|------|----------|-----------|-----------------|
| **Top Nav Bar** | 3-6 items, SaaS | Low | Hamburger drawer |
| **Sidebar** | 7+ items, dashboards | Medium | Bottom tab bar or overlay |
| **Mega Menu** | E-commerce, content sites | High | Accordion list |
| **Bottom Tab Bar** | 4-5 items, mobile-first | Low | Native pattern |
| **Command Palette** | Power users, dev tools | Medium | Keyboard trigger |
| **Floating Dock** | Creative tools, macOS-style | Medium | Shrinks to center items |
| **Breadcrumbs** | Deep hierarchies (4+ levels) | Low | Scroll horizontally |

---

## 2. Top Navigation Bar

```tsx
function TopNav() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  return (
    <header className={`
      fixed top-0 left-0 right-0 z-50
      transition-all duration-300
      ${scrolled
        ? 'bg-surface/80 backdrop-blur-xl border-b shadow-sm'
        : 'bg-transparent'
      }
    `}>
      <div className="max-w-7xl mx-auto px-[--page-gutter] h-16 flex items-center justify-between">
        {/* Logo */}
        <a href="/" className="text-lg font-bold tracking-tight shrink-0">
          Brand
        </a>

        {/* Desktop Links */}
        <nav className="hidden md:flex items-center gap-1" aria-label="Main">
          {navItems.map(item => (
            <NavLink key={item.href} {...item} />
          ))}
        </nav>

        {/* Desktop Actions */}
        <div className="hidden md:flex items-center gap-3">
          <SearchTrigger />
          <ThemeToggle />
          <UserMenu />
        </div>

        {/* Mobile Toggle */}
        <button
          onClick={() => setMobileOpen(!mobileOpen)}
          className="md:hidden p-2 -mr-2"
          aria-label={mobileOpen ? 'Close menu' : 'Open menu'}
          aria-expanded={mobileOpen}
        >
          <Menu size={20} />
        </button>
      </div>

      {/* Mobile Drawer */}
      <AnimatePresence>
        {mobileOpen && (
          <MobileDrawer items={navItems} onClose={() => setMobileOpen(false)} />
        )}
      </AnimatePresence>
    </header>
  );
}
```

### NavLink with Active Indicator
```tsx
function NavLink({ href, label, badge }: { href: string; label: string; badge?: string }) {
  const isActive = useLocation().pathname === href;

  return (
    <a
      href={href}
      className={`
        relative px-3 py-2 text-sm font-medium rounded-lg transition-all duration-200
        ${isActive
          ? 'text-foreground bg-muted/10'
          : 'text-muted hover:text-foreground hover:bg-muted/5'
        }
      `}
    >
      {label}
      {badge && (
        <span className="absolute -top-1 -right-1 bg-primary text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full leading-none">
          {badge}
        </span>
      )}
      {isActive && (
        <motion.div
          layoutId="nav-active"
          className="absolute bottom-0 left-3 right-3 h-0.5 bg-primary rounded-full"
          transition={{ type: 'spring', stiffness: 500, damping: 35 }}
        />
      )}
    </a>
  );
}
```

---

## 3. Sidebar Navigation (Dashboard)

```tsx
interface SidebarItem {
  label: string;
  icon: React.ReactNode;
  href?: string;
  children?: { label: string; href: string; badge?: string }[];
  badge?: string;
}

function Sidebar({ items, collapsed = false }: { items: SidebarItem[]; collapsed?: boolean }) {
  return (
    <aside className={`
      h-screen sticky top-0
      bg-surface border-r
      flex flex-col
      transition-all duration-300 ease-in-out
      ${collapsed ? 'w-[72px]' : 'w-64'}
    `}>
      {/* Logo Area */}
      <div className="h-16 flex items-center px-5 border-b shrink-0">
        {collapsed ? (
          <div className="w-8 h-8 bg-primary rounded-lg mx-auto" />
        ) : (
          <span className="text-lg font-bold tracking-tight">Dashboard</span>
        )}
      </div>

      {/* Nav Items */}
      <nav className="flex-1 overflow-y-auto py-4 px-3 space-y-1" aria-label="Sidebar">
        {items.map(item => (
          <SidebarItem key={item.label} item={item} collapsed={collapsed} />
        ))}
      </nav>

      {/* User Footer */}
      <div className="border-t p-3">
        <UserMenu collapsed={collapsed} />
      </div>
    </aside>
  );
}
```

### Collapsible Sidebar Item
```tsx
function SidebarItem({ item, collapsed }: { item: SidebarItem; collapsed: boolean }) {
  const [expanded, setExpanded] = useState(false);
  const isActive = item.href ? useLocation().pathname === item.href : false;
  const hasChildren = !!item.children?.length;

  const content = (
    <a
      href={item.href || '#'}
      onClick={hasChildren ? (e) => { e.preventDefault(); setExpanded(!expanded); } : undefined}
      className={`
        flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium
        transition-all duration-150 cursor-pointer
        ${isActive
          ? 'bg-primary/10 text-primary'
          : 'text-muted hover:text-foreground hover:bg-muted/5'
        }
        ${collapsed ? 'justify-center px-2' : ''}
      `}
    >
      <span className="shrink-0 w-5 h-5 flex items-center justify-center">{item.icon}</span>
      {!collapsed && (
        <>
          <span className="flex-1 truncate">{item.label}</span>
          {item.badge && (
            <span className="text-[10px] font-bold bg-primary text-white px-1.5 py-0.5 rounded-full">
              {item.badge}
            </span>
          )}
          {hasChildren && (
            <ChevronRight size={14} className={`transition-transform ${expanded ? 'rotate-90' : ''}`} />
          )}
        </>
      )}
    </a>
  );

  return (
    <div>
      {collapsed ? (
        <Tooltip content={item.label} side="right">
          {content}
        </Tooltip>
      ) : content}

      {/* Children */}
      {hasChildren && expanded && !collapsed && (
        <motion.div
          initial={{ height: 0, opacity: 0 }}
          animate={{ height: 'auto', opacity: 1 }}
          exit={{ height: 0, opacity: 0 }}
          className="ml-8 mt-1 space-y-1 overflow-hidden"
        >
          {item.children!.map(child => (
            <SidebarChild key={child.href} {...child} />
          ))}
        </motion.div>
      )}
    </div>
  );
}
```

---

## 4. Mega Menu (E-Commerce / Content-Rich)

```tsx
function MegaMenu({ categories }: { categories: MegaCategory[] }) {
  const [activeIdx, setActiveIdx] = useState<number | null>(null);
  const timeoutRef = useRef<ReturnType<typeof setTimeout>>();

  const showMenu = (idx: number) => {
    clearTimeout(timeoutRef.current);
    setActiveIdx(idx);
  };

  const hideMenu = () => {
    timeoutRef.current = setTimeout(() => setActiveIdx(null), 150);
  };

  return (
    <nav className="relative" onMouseLeave={hideMenu} aria-label="Categories">
      {/* Top-Level Categories */}
      <div className="flex items-center gap-1">
        {categories.map((cat, i) => (
          <button
            key={cat.label}
            onMouseEnter={() => showMenu(i)}
            onFocus={() => showMenu(i)}
            className={`px-3 py-2 text-sm font-medium rounded-lg transition-colors
              ${activeIdx === i ? 'text-foreground bg-muted/10' : 'text-muted hover:text-foreground'}
            `}
            aria-expanded={activeIdx === i}
          >
            {cat.label}
          </button>
        ))}
      </div>

      {/* Dropdown Panel */}
      <AnimatePresence>
        {activeIdx !== null && (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 8 }}
            transition={{ duration: 0.15 }}
            onMouseEnter={() => clearTimeout(timeoutRef.current)}
            className="absolute top-full left-0 right-0 mt-2
              bg-surface/95 backdrop-blur-xl border rounded-2xl shadow-2xl
              p-8 grid grid-cols-4 gap-8 z-50"
          >
            {categories[activeIdx].columns.map(col => (
              <div key={col.title}>
                <h4 className="text-xs font-semibold text-muted uppercase tracking-wider mb-3">
                  {col.title}
                </h4>
                <ul className="space-y-2">
                  {col.links.map(link => (
                    <li key={link.label}>
                      <a href={link.href} className="text-sm text-muted hover:text-foreground transition-colors flex items-center gap-2 group">
                        <span className="group-hover:translate-x-1 transition-transform">{link.label}</span>
                        {link.badge && (
                          <span className="text-[10px] bg-primary/10 text-primary px-1.5 py-0.5 rounded font-medium">{link.badge}</span>
                        )}
                      </a>
                    </li>
                  ))}
                </ul>
              </div>
            ))}

            {/* Featured Card */}
            {categories[activeIdx].featured && (
              <div className="col-span-1 bg-muted/5 rounded-xl p-4">
                <img src={categories[activeIdx].featured!.image} className="rounded-lg mb-3" />
                <p className="text-sm font-medium">{categories[activeIdx].featured!.title}</p>
                <p className="text-xs text-muted mt-1">{categories[activeIdx].featured!.description}</p>
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </nav>
  );
}
```

---

## 5. Command Palette (⌘K / Ctrl+K)

```tsx
function CommandPalette() {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [activeIndex, setActiveIndex] = useState(0);

  useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if (e.key === 'k' && (e.metaKey || e.ctrlKey)) {
        e.preventDefault();
        setOpen(o => !o);
      }
    };
    document.addEventListener('keydown', down);
    return () => document.removeEventListener('keydown', down);
  }, []);

  const filteredCommands = commands.filter(c =>
    c.label.toLowerCase().includes(query.toLowerCase())
  );

  useEffect(() => { setActiveIndex(0); }, [query]);

  const handleKeyDown = (e: KeyboardEvent) => {
    if (e.key === 'ArrowDown') { e.preventDefault(); setActiveIndex(i => Math.min(i + 1, filteredCommands.length - 1)); }
    if (e.key === 'ArrowUp') { e.preventDefault(); setActiveIndex(i => Math.max(i - 1, 0)); }
    if (e.key === 'Enter' && filteredCommands[activeIndex]) {
      filteredCommands[activeIndex].action();
      setOpen(false);
    }
  };

  return (
    <AnimatePresence>
      {open && (
        <>
          <motion.div
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/40 backdrop-blur-sm z-50"
            onClick={() => setOpen(false)}
          />

          <motion.div
            initial={{ opacity: 0, scale: 0.96, y: -20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.96, y: -20 }}
            transition={{ duration: 0.15 }}
            className="fixed top-[20%] left-1/2 -translate-x-1/2 w-full max-w-lg z-50"
          >
            <div className="bg-surface/95 backdrop-blur-xl border rounded-2xl shadow-2xl overflow-hidden" onKeyDown={handleKeyDown}>
              <div className="flex items-center gap-3 px-4 py-3 border-b">
                <Search size={16} className="text-muted shrink-0" />
                <input
                  value={query}
                  onChange={e => setQuery(e.target.value)}
                  placeholder="Search commands..."
                  className="flex-1 bg-transparent text-sm outline-none"
                  autoFocus
                />
                <kbd className="text-[10px] text-muted bg-muted/10 px-1.5 py-0.5 rounded font-mono">ESC</kbd>
              </div>

              <div className="max-h-80 overflow-y-auto py-2">
                {filteredCommands.map((cmd, i) => (
                  <button
                    key={cmd.label}
                    onClick={() => { cmd.action(); setOpen(false); }}
                    className={`w-full flex items-center gap-3 px-4 py-2.5 text-sm transition-colors
                      ${i === activeIndex ? 'bg-muted/10 text-foreground' : 'text-muted'}
                    `}
                  >
                    <span className="w-5 h-5 flex items-center justify-center">{cmd.icon}</span>
                    <span className="flex-1 text-left">{cmd.label}</span>
                    {cmd.shortcut && (
                      <kbd className="text-[10px] text-muted font-mono">{cmd.shortcut}</kbd>
                    )}
                  </button>
                ))}
              </div>
            </div>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
```

---

## 6. Breadcrumbs (Deep Hierarchies)

```tsx
function Breadcrumbs({
  items,
  maxItems = 4,
}: {
  items: { label: string; href?: string }[];
  maxItems?: number;
}) {
  const collapsed = items.length > maxItems;

  return (
    <nav aria-label="Breadcrumb" className="flex items-center gap-1.5 text-sm">
      <ol className="flex items-center gap-1.5 flex-wrap">
        {collapsed ? (
          <>
            {/* First item */}
            <BreadcrumbItem item={items[0]} />
            <ChevronRight size={12} className="text-muted/50" />

            {/* Collapsed indicator */}
            <li>
              <button className="text-muted hover:text-foreground px-1" title="Show full path">
                ...
              </button>
            </li>
            <ChevronRight size={12} className="text-muted/50" />

            {/* Last 2 items */}
            {items.slice(-2).map((item, i) => (
              <React.Fragment key={item.label}>
                {i > 0 && <ChevronRight size={12} className="text-muted/50" />}
                <BreadcrumbItem item={item} />
              </React.Fragment>
            ))}
          </>
        ) : (
          items.map((item, i) => (
            <React.Fragment key={item.label}>
              {i > 0 && <ChevronRight size={12} className="text-muted/50" />}
              <BreadcrumbItem item={item} isLast={i === items.length - 1} />
            </React.Fragment>
          ))
        )}
      </ol>
    </nav>
  );
}

function BreadcrumbItem({ item, isLast }: { item: { label: string; href?: string }; isLast?: boolean }) {
  return (
    <li>
      {isLast || !item.href ? (
        <span className="text-foreground font-medium" aria-current={isLast ? 'page' : undefined}>
          {item.label}
        </span>
      ) : (
        <a href={item.href} className="text-muted hover:text-foreground transition-colors">
          {item.label}
        </a>
      )}
    </li>
  );
}
```

---

## 7. Tab Navigation

```tsx
function Tabs({ tabs, activeTab, onChange }: {
  tabs: { id: string; label: string; count?: number }[];
  activeTab: string;
  onChange: (id: string) => void;
}) {
  return (
    <div className="border-b" role="tablist">
      <div className="flex gap-0 -mb-px">
        {tabs.map(tab => (
          <button
            key={tab.id}
            role="tab"
            aria-selected={activeTab === tab.id}
            onClick={() => onChange(tab.id)}
            className={`
              relative px-4 py-3 text-sm font-medium transition-colors
              ${activeTab === tab.id
                ? 'text-foreground'
                : 'text-muted hover:text-foreground'
              }
            `}
          >
            {tab.label}
            {tab.count !== undefined && (
              <span className={`ml-1.5 text-xs px-1.5 py-0.5 rounded-full
                ${activeTab === tab.id ? 'bg-primary/10 text-primary' : 'bg-muted/10 text-muted'}
              `}>
                {tab.count}
              </span>
            )}
            {activeTab === tab.id && (
              <motion.div
                layoutId="tab-indicator"
                className="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"
                transition={{ type: 'spring', stiffness: 500, damping: 35 }}
              />
            )}
          </button>
        ))}
      </div>
    </div>
  );
}
```

---

## 8. Floating Dock (macOS / Creative Tools)

```tsx
function FloatingDock({ items }: { items: DockItem[] }) {
  const [hoveredIdx, setHoveredIdx] = useState<number | null>(null);

  return (
    <div className="fixed bottom-6 left-1/2 -translate-x-1/2 z-50">
      <div className="
        flex items-end gap-2
        bg-surface/70 backdrop-blur-2xl
        border border-white/20
        rounded-2xl
        px-3 py-2
        shadow-2xl
      ">
        {items.map((item, i) => {
          const scale = hoveredIdx === null ? 1
            : i === hoveredIdx ? 1.4
            : 1 - 0.1 * Math.abs(i - hoveredIdx);

          return (
            <motion.button
              key={item.label}
              animate={{ scale }}
              onHoverStart={() => setHoveredIdx(i)}
              onHoverEnd={() => setHoveredIdx(null)}
              className="w-10 h-10 rounded-xl bg-muted/10 flex items-center justify-center text-muted hover:text-foreground transition-colors relative group"
            >
              {item.icon}
              <span className="absolute -top-8 left-1/2 -translate-x-1/2 bg-foreground text-background text-[10px] px-2 py-0.5 rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap pointer-events-none">
                {item.label}
              </span>
            </motion.button>
          );
        })}
      </div>
    </div>
  );
}
```

---

## 9. Mobile Bottom Tab Bar

```tsx
function BottomTabBar({ tabs }: { tabs: TabItem[] }) {
  const location = useLocation();

  return (
    <nav className="
      fixed bottom-0 left-0 right-0 z-50
      bg-surface/95 backdrop-blur-xl
      border-t
      h-16
      pb-[env(safe-area-inset-bottom)]
      flex items-center justify-around
      px-2
    ">
      {tabs.map(tab => {
        const active = location.pathname === tab.href;
        return (
          <a
            key={tab.href}
            href={tab.href}
            className={`
              flex flex-col items-center justify-center gap-0.5
              min-w-[48px] min-h-[48px]
              relative
              transition-colors duration-200
              ${active ? 'text-primary' : 'text-muted'}
            `}
          >
            {active && (
              <motion.div
                layoutId="bottom-tab-bg"
                className="absolute inset-1 bg-primary/10 rounded-xl"
                transition={{ type: 'spring', stiffness: 500, damping: 35 }}
              />
            )}
            <span className="relative z-10 w-5 h-5 flex items-center justify-center">{tab.icon}</span>
            <span className="relative z-10 text-[10px] font-medium">{tab.label}</span>
          </a>
        );
      })}
    </nav>
  );
}
```

---

## 10. Navigation Anti-Patterns

```
❌ Mystery meat navigation (icons without labels — always show labels)
❌ Deep nesting (3+ levels — flatten or use breadcrumbs)
❌ Changing nav position between pages (consistency killer)
❌ Auto-opening mega menus on hover without delay (accidental triggers)
❌ Hiding the active state indicator (where am I?)
❌ Scroll-jacking nav (don't auto-hide nav unless reading-focused UI)
❌ Non-keyboard accessible submenus (Tab should open, Escape should close)
❌ Hamburger on desktop (> 4 items → redesign nav, don't hide it)
```
