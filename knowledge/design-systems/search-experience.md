# Search Experience — Premium Search UX Patterns

Search is a conversation between user and data. Search bar variants, autocomplete, faceted search, filters, sort, and results display for premium applications.

---

## 1. Search Bar Variants

### A. Inline Search (header, universal)
```tsx
function InlineSearch() {
  const [query, setQuery] = useState('');
  const [open, setOpen] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        inputRef.current?.focus();
      }
    };
    document.addEventListener('keydown', down);
    return () => document.removeEventListener('keydown', down);
  }, []);

  return (
    <div className="relative w-full max-w-md">
      <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted pointer-events-none" />
      <input
        ref={inputRef}
        value={query}
        onChange={e => { setQuery(e.target.value); setOpen(true); }}
        onFocus={() => setOpen(true)}
        placeholder="Search..."
        className="input-pill h-[40px] w-full pl-9 pr-16 text-sm bg-muted/5"
        role="combobox"
        aria-expanded={open}
      />
      <div className="absolute right-2 top-1/2 -translate-y-1/2 flex items-center gap-1">
        {query && (
          <button onClick={() => { setQuery(''); inputRef.current?.focus(); }} className="p-1 hover:bg-muted/10 rounded" aria-label="Clear">
            <X size={14} className="text-muted" />
          </button>
        )}
        <kbd className="hidden sm:inline-flex items-center gap-0.5 text-[10px] text-muted bg-muted/10 px-1.5 py-0.5 rounded font-mono">
          <span className="text-xs">⌘</span>K
        </kbd>
      </div>

      {open && query.length >= 2 && (
        <SearchResults query={query} onClose={() => setOpen(false)} />
      )}
    </div>
  );
}
```

### B. Full-Screen Search Overlay (content-heavy)
```tsx
function FullscreenSearch({ open, onClose }: { open: boolean; onClose: () => void }) {
  const [query, setQuery] = useState('');

  useEffect(() => {
    if (open) setQuery('');
  }, [open]);

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 bg-background/95 backdrop-blur-xl"
        >
          <div className="max-w-3xl mx-auto pt-20 px-[--page-gutter]">
            {/* Search Input */}
            <div className="relative mb-8">
              <Search size={20} className="absolute left-0 top-1/2 -translate-y-1/2 text-muted" />
              <input
                value={query}
                onChange={e => setQuery(e.target.value)}
                placeholder="Search documentation..."
                className="w-full bg-transparent border-0 border-b-2 border-border focus:border-primary
                  text-2xl py-4 pl-9 pr-10 outline-none transition-colors placeholder:text-muted/40"
                autoFocus
              />
              <button onClick={onClose} className="absolute right-0 top-1/2 -translate-y-1/2 p-2" aria-label="Close search">
                <X size={20} className="text-muted" />
              </button>
            </div>

            {/* Results */}
            {query && <SearchResults query={query} onClose={onClose} />}

            {/* Quick links when empty */}
            {!query && (
              <div className="grid grid-cols-2 gap-2">
                {quickLinks.map(link => (
                  <a key={link.href} href={link.href} onClick={onClose}
                    className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted/5 transition-colors text-sm">
                    {link.icon} {link.label}
                  </a>
                ))}
              </div>
            )}
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
```

### C. Hero Search Bar (landing page)
```css
.hero-search {
  width: 100%;
  max-width: 640px;
  height: 56px;
  border-radius: 16px;
  border: 1.5px solid var(--color-border);
  background: var(--color-surface);
  box-shadow: 0 4px 24px rgba(0,0,0,0.06);
  padding: 0 56px 0 20px;
  font-size: 16px;
  transition: box-shadow 0.2s, border-color 0.2s;
}
.hero-search:focus {
  border-color: var(--color-primary);
  box-shadow: 0 4px 24px rgba(var(--primary-rgb), 0.15);
  outline: none;
}
```

---

## 2. Autocomplete / Typeahead

```tsx
interface SearchResult {
  id: string;
  title: string;
  subtitle?: string;
  type: 'page' | 'product' | 'user' | 'article';
  url: string;
  icon?: React.ReactNode;
}

function SearchResults({ query, onClose }: { query: string; onClose: () => void }) {
  const { data, isLoading } = useQuery({
    queryKey: ['search', query],
    queryFn: () => fetchSearchResults(query),
    enabled: query.length >= 2,
  });

  const [activeIndex, setActiveIndex] = useState(-1);

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!data) return;
    if (e.key === 'ArrowDown') { e.preventDefault(); setActiveIndex(i => Math.min(i + 1, data.length - 1)); }
    if (e.key === 'ArrowUp') { e.preventDefault(); setActiveIndex(i => Math.max(i - 1, -1)); }
    if (e.key === 'Enter' && activeIndex >= 0 && data[activeIndex]) {
      window.location.href = data[activeIndex].url;
      onClose();
    }
    if (e.key === 'Escape') onClose();
  };

  return (
    <div
      className="absolute top-full mt-2 w-full bg-surface border rounded-xl shadow-xl overflow-hidden z-50"
      onKeyDown={handleKeyDown}
      role="listbox"
    >
      {isLoading && (
        <div className="px-4 py-3 text-sm text-muted flex items-center gap-2">
          <Spinner size={14} /> Searching...
        </div>
      )}

      {data?.length === 0 && query.length >= 2 && (
        <div className="px-4 py-6 text-center text-sm text-muted">
          No results for "<strong>{query}</strong>"
        </div>
      )}

      {data?.map((result, i) => (
        <a
          key={result.id}
          href={result.url}
          onClick={onClose}
          className={`flex items-center gap-3 px-4 py-3 text-sm transition-colors
            ${i === activeIndex ? 'bg-muted/10' : 'hover:bg-muted/5'}
          `}
          role="option"
          aria-selected={i === activeIndex}
        >
          <span className="shrink-0 w-8 h-8 rounded-lg bg-muted/5 flex items-center justify-center text-muted">
            {result.icon || <File size={14} />}
          </span>
          <div className="min-w-0">
            <p className="font-medium truncate">
              <HighlightMatch text={result.title} query={query} />
            </p>
            {result.subtitle && (
              <p className="text-xs text-muted truncate">{result.subtitle}</p>
            )}
          </div>
          <span className="text-[10px] text-muted uppercase tracking-wider ml-auto shrink-0">
            {result.type}
          </span>
        </a>
      ))}
    </div>
  );
}
```

### Text Highlighting
```tsx
function HighlightMatch({ text, query }: { text: string; query: string }) {
  if (!query) return <>{text}</>;
  const parts = text.split(new RegExp(`(${escapeRegex(query)})`, 'gi'));
  return (
    <>
      {parts.map((part, i) =>
        part.toLowerCase() === query.toLowerCase()
          ? <mark key={i} className="bg-primary/20 text-inherit rounded-sm px-0.5">{part}</mark>
          : part
      )}
    </>
  );
}
```

---

## 3. Faceted Search / Filters

```tsx
interface FilterGroup {
  label: string;
  type: 'checkbox' | 'range' | 'select';
  options: { label: string; value: string; count?: number }[];
}

function FacetedSearch({ filters, active, onChange }: {
  filters: FilterGroup[];
  active: Record<string, string[]>;
  onChange: (group: string, values: string[]) => void;
}) {
  return (
    <aside className="w-64 shrink-0">
      {filters.map(group => (
        <div key={group.label} className="py-4 border-b last:border-0">
          <h4 className="text-xs font-semibold text-muted uppercase tracking-wider mb-3">
            {group.label}
          </h4>

          {group.type === 'checkbox' && (
            <div className="space-y-1">
              {group.options.map(option => {
                const checked = active[group.label]?.includes(option.value);
                return (
                  <label key={option.value} className="flex items-center gap-2 py-1.5 text-sm cursor-pointer group">
                    <input
                      type="checkbox"
                      checked={checked}
                      onChange={() => {
                        const current = active[group.label] || [];
                        onChange(group.label, checked
                          ? current.filter(v => v !== option.value)
                          : [...current, option.value]
                        );
                      }}
                      className="rounded accent-primary"
                    />
                    <span className="flex-1 group-hover:text-foreground transition-colors">
                      {option.label}
                    </span>
                    {option.count !== undefined && (
                      <span className="text-xs text-muted tabular-nums">
                        {option.count}
                      </span>
                    )}
                  </label>
                );
              })}
            </div>
          )}

          {group.type === 'range' && (
            <div className="space-y-2">
              <div className="flex gap-2">
                <input placeholder="Min" className="input-outlined h-[32px] w-full px-2 text-xs" />
                <span className="text-muted text-xs self-center">—</span>
                <input placeholder="Max" className="input-outlined h-[32px] w-full px-2 text-xs" />
              </div>
            </div>
          )}
        </div>
      ))}

      {/* Active filter chips */}
      {Object.values(active).some(v => v.length > 0) && (
        <div className="pt-3">
          <button
            onClick={() => Object.keys(active).forEach(k => onChange(k, []))}
            className="text-xs text-primary hover:underline"
          >
            Clear all filters
          </button>
        </div>
      )}
    </aside>
  );
}
```

### Filter Chips (horizontal, scrollable)
```tsx
function FilterChips({ filters, active, onToggle }: {
  filters: { label: string; value: string }[];
  active: string[];
  onToggle: (value: string) => void;
}) {
  const scrollRef = useRef<HTMLDivElement>(null);

  return (
    <div
      ref={scrollRef}
      className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide"
      role="group"
      aria-label="Filters"
    >
      {filters.map(f => {
        const isActive = active.includes(f.value);
        return (
          <button
            key={f.value}
            onClick={() => onToggle(f.value)}
            className={`
              shrink-0 px-3 py-1.5 rounded-full text-sm font-medium
              transition-all duration-200
              ${isActive
                ? 'bg-primary text-white shadow-sm'
                : 'bg-muted/5 text-muted hover:text-foreground hover:bg-muted/10 border'
              }
            `}
          >
            {f.label}
          </button>
        );
      })}
    </div>
  );
}
```

---

## 4. Sort Controls

```tsx
function SortDropdown({ value, onChange }: {
  value: string;
  onChange: (v: string) => void;
}) {
  return (
    <select
      value={value}
      onChange={e => onChange(e.target.value)}
      className="
        appearance-none bg-surface border rounded-lg
        pl-3 pr-8 py-2 text-sm
        cursor-pointer
        bg-[url('data:image/svg+xml,...')] bg-[right_8px_center] bg-[length:12px]
      "
      aria-label="Sort by"
    >
      <option value="relevance">Relevance</option>
      <option value="newest">Newest first</option>
      <option value="oldest">Oldest first</option>
      <option value="price-asc">Price: Low to high</option>
      <option value="price-desc">Price: High to low</option>
      <option value="popular">Most popular</option>
    </select>
  );
}
```

---

## 5. Search Result Card

```tsx
function SearchResultCard({ result }: { result: SearchResult }) {
  return (
    <article className="py-5 border-b last:border-0 hover:bg-muted/3 transition-colors -mx-4 px-4 rounded-lg">
      <div className="flex items-start gap-3">
        {result.image && (
          <img src={result.image} alt="" className="w-16 h-16 rounded-lg object-cover shrink-0" />
        )}
        <div className="min-w-0">
          <div className="flex items-center gap-2 mb-0.5">
            <span className="text-[10px] text-muted uppercase tracking-wider">{result.type}</span>
            {result.category && (
              <>
                <span className="text-muted/30">/</span>
                <span className="text-[10px] text-muted">{result.category}</span>
              </>
            )}
          </div>
          <h3>
            <a href={result.url} className="text-base font-semibold hover:text-primary transition-colors">
              <HighlightMatch text={result.title} query={query} />
            </a>
          </h3>
          <p className="text-sm text-muted mt-1 line-clamp-2">{result.description}</p>
          {result.tags && (
            <div className="flex gap-1 mt-2">
              {result.tags.map(tag => (
                <span key={tag} className="text-[10px] bg-muted/5 px-1.5 py-0.5 rounded">{tag}</span>
              ))}
            </div>
          )}
        </div>
      </div>
    </article>
  );
}
```

---

## 6. No Results vs Empty Search

```tsx
function SearchStateHandler({
  query,
  isLoading,
  results,
  filters,
}: {
  query: string;
  isLoading: boolean;
  results: any[] | null;
  filters: Record<string, string[]>;
}) {
  const hasFilters = Object.values(filters).some(v => v.length > 0);

  if (isLoading) return <ResultsSkeleton />;

  // Initial state — no query
  if (!query && !hasFilters) {
    return (
      <div className="text-center py-16">
        <Search size={32} className="text-muted/30 mx-auto mb-3" />
        <p className="text-muted text-sm">Type to start searching</p>
      </div>
    );
  }

  // No results with query
  if (results?.length === 0) {
    return (
      <div className="text-center py-16">
        <Search size={32} className="text-muted/30 mx-auto mb-3" />
        <p className="text-sm font-medium mb-1">No results for "{query}"</p>
        <p className="text-xs text-muted mb-4">
          {hasFilters
            ? 'Try adjusting your filters or search term'
            : 'Try a different search term or browse categories'}
        </p>
        {hasFilters && (
          <button onClick={() => clearAllFilters()} className="text-sm text-primary hover:underline">
            Clear all filters
          </button>
        )}
      </div>
    );
  }

  return <ResultsList results={results} />;
}
```

---

## 7. Live Search with Debounce

```tsx
function useDebouncedSearch(delay = 300) {
  const [query, setQuery] = useState('');
  const [debouncedQuery, setDebouncedQuery] = useState('');

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedQuery(query), delay);
    return () => clearTimeout(timer);
  }, [query, delay]);

  // Actual API query uses debouncedQuery
  const { data, isLoading } = useQuery({
    queryKey: ['search', debouncedQuery],
    queryFn: () => fetchSearch(debouncedQuery),
    enabled: debouncedQuery.length >= 2,
  });

  return { query, setQuery, results: data, isLoading };
}
```

---

## 8. Search UX Checklist

```
✓ Debounce input by 250-350ms (avoid excessive API calls)
✓ Minimum 2 characters before searching
✓ Show loading indicator for network requests
✓ Keyboard navigation (Arrow keys + Enter + Escape)
✓ ⌘K shortcut to focus search (desktop convention)
✓ Highlight matching text in results
✓ Show result type icon/badge (page, product, article)
✓ Preserve search query in URL (?q=...)
✓ Empty state: differentiate "no query" vs "no results"
✓ Active filter count badge on mobile filter button
✓ Screen reader announcements for result count changes
✓ Recent searches stored in localStorage (optional)
```
