# shadcn/ui — API Reference

## Overview
**Version:** v4 (current as of 2026-05-16)
**Repository:** https://github.com/shadcn-ui/ui
**Registry path:** `apps/v4/registry/new-york-v4/ui/`

## Setup
```bash
npx shadcn@latest init          # one-time setup (creates components.json)
npx shadcn@latest add button    # add a single component
npx shadcn@latest add button card dialog form  # add multiple components
```

## Architecture
- **NOT an npm package** — components are copied into your project at `@/components/ui/`
- **Built on Radix UI primitives** (radix-ui package) + Tailwind CSS v4
- **Fully customizable** — you own the source code, edit directly
- **CVA** (class-variance-authority) for component variants
- **tailwind-merge + clsx** for conflict-free className merging via `cn()` utility
- **Radix Slot** (`asChild` prop) for polymorphic components
- **data-slot** attributes on all components for CSS targeting
- **dark mode** via Tailwind `dark:` prefix + next-themes integration
- **CSS custom properties** for theme tokens (e.g., `var(--radius)`, `var(--border)`)
- **Animation system** uses Tailwind v4 `animate-in`/`animate-out` keyframes
- **Icons:** lucide-react exclusively

## Core Utility: cn()
```typescript
import { clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

## Component List (55 total)

### 1. Accordion
**Based on:** `@radix-ui/react-accordion` (as "Accordion as AccordionPrimitive" from `radix-ui`)
**Sub-parts:** Accordion, AccordionItem, AccordionTrigger, AccordionContent
**Key props:** type ("single" | "multiple"), collapsible, defaultValue
**Usage:**
```tsx
<Accordion type="single" collapsible>
  <AccordionItem value="item-1">
    <AccordionTrigger>Section 1</AccordionTrigger>
    <AccordionContent>Content here</AccordionContent>
  </AccordionItem>
</Accordion>
```

### 2. Alert
**Sub-parts:** Alert, AlertTitle, AlertDescription
**Variants:** default, destructive
**Props:** variant, className
**Usage:** `<Alert variant="destructive"><AlertTitle>Error</AlertTitle><AlertDescription>Something went wrong.</AlertDescription></Alert>`

### 3. AlertDialog
**Based on:** `@radix-ui/react-alert-dialog` (from `radix-ui`)
**Sub-parts:** AlertDialog, AlertDialogTrigger, AlertDialogContent, AlertDialogHeader, AlertDialogFooter, AlertDialogTitle, AlertDialogDescription, AlertDialogAction, AlertDialogCancel
**Props:** All Radix AlertDialog props

### 4. AspectRatio
**Based on:** `@radix-ui/react-aspect-ratio` (from `radix-ui`)
**Props:** ratio (default 1/1), className
**Usage:** `<AspectRatio ratio={16/9}><img src="..." /></AspectRatio>`

### 5. Avatar
**Based on:** `@radix-ui/react-avatar` (from `radix-ui`)
**Sub-parts:** Avatar, AvatarImage, AvatarFallback
**Props:** className (Avatar), src/alt (AvatarImage), delayMs (AvatarImage)

### 6. Badge
**Standalone, no Radix dependency**
**Variants:** default, secondary, destructive, outline, ghost, link
**Props:** variant, asChild, className
**Renders as:** `<span>` (or Slot when asChild)
**Usage:** `<Badge variant="destructive">New</Badge>`
**Exports:** Badge, badgeVariants

### 7. Breadcrumb
**Standalone, no Radix dependency**
**Sub-parts:** Breadcrumb, BreadcrumbList, BreadcrumbItem, BreadcrumbLink, BreadcrumbPage, BreadcrumbSeparator, BreadcrumbEllipsis
**Props:** asChild (BreadcrumbLink), className (all)

### 8. Button
**Standalone, uses Radix Slot for asChild**
**Variants:** default, destructive, outline, secondary, ghost, link
**Sizes:** default, xs, sm, lg, icon, icon-xs, icon-sm, icon-lg
**Props:** variant, size, asChild, className (+ all button HTML attrs)
**Imports:** CVA, Slot from `radix-ui`
**Exports:** Button, buttonVariants
**Usage:** `<Button variant="destructive" size="lg">Delete</Button>`

### 9. ButtonGroup
**Extends Button with grouping**
**Variants:** default, outline, ghost, link
**Sizes:** default, xs, sm, lg
**Props:** variant, size, orientation ("horizontal" | "vertical"), className (on ButtonGroup, ButtonGroupText, ButtonGroupInput)

### 10. Calendar
**Based on:** `react-day-picker` v9
**Sub-parts:** Calendar (single component)
**Props:** mode ("single" | "range" | "multiple"), selected, onSelect, className
**Styling:** Extensive CSS class overrides for react-day-picker internals
**Usage:** `<Calendar mode="single" selected={date} onSelect={setDate} />`

### 11. Card
**Standalone, no Radix dependency**
**Sub-parts:** Card, CardHeader, CardTitle, CardDescription, CardAction, CardContent, CardFooter
**Props:** className only (all div wrappers)
**Usage:**
```tsx
<Card>
  <CardHeader>
    <CardTitle>Title</CardTitle>
    <CardDescription>Description</CardDescription>
    <CardAction><Button>Action</Button></CardAction>
  </CardHeader>
  <CardContent>Content</CardContent>
  <CardFooter>Footer</CardFooter>
</Card>
```

### 12. Carousel
**Based on:** `embla-carousel-react`
**Sub-parts:** Carousel, CarouselContent, CarouselItem, CarouselPrevious, CarouselNext
**Props:** orientation ("horizontal" | "vertical"), opts (Embla options), plugins, setApi
**Exports:** type CarouselApi, Carousel, CarouselContent, CarouselItem, CarouselPrevious, CarouselNext

### 13. Chart
**Based on:** `recharts`
**Sub-parts:** ChartContainer, ChartTooltip, ChartTooltipContent, ChartLegend, ChartLegendContent, ChartStyle
**Props:** config (ChartConfig), id, initialDimension
**Theming:** CSS custom properties (`--color-{key}`), dark mode via `.dark` selector
**Features:** Auto-generated CSS theme variables from config, responsive container
**Exports:** ChartContainer, ChartTooltip, ChartTooltipContent, ChartLegend, ChartLegendContent, ChartStyle

### 14. Checkbox
**Based on:** `radix-ui` (Checkbox primitive)
**Sub-parts:** Checkbox, CheckboxIndicator
**Props:** All Radix Checkbox props

### 15. Collapsible
**Based on:** `radix-ui` (Collapsible primitive)
**Sub-parts:** Collapsible, CollapsibleTrigger, CollapsibleContent
**Props:** open, onOpenChange, defaultOpen

### 16. Combobox
**Based on:** `@radix-ui/react-popover` + Command component (cmdk)
**Sub-parts:** Combobox, ComboboxInput, ComboboxList, ComboboxOption, ComboboxEmpty, ComboboxGroup
**Props:** value, onChange, defaultValue, searchPlaceholder, emptyText

### 17. Command
**Based on:** `cmdk` (as CommandPrimitive)
**Sub-parts:** Command, CommandDialog, CommandInput, CommandList, CommandEmpty, CommandGroup, CommandItem, CommandShortcut, CommandSeparator
**Features:** Keyboard navigation, filtering, dialog wrapper
**Usage:**
```tsx
<Command>
  <CommandInput placeholder="Type a command..." />
  <CommandList>
    <CommandEmpty>No results found.</CommandEmpty>
    <CommandGroup heading="Suggestions">
      <CommandItem>
        <CalendarIcon />
        <span>Calendar</span>
        <CommandShortcut>⌘C</CommandShortcut>
      </CommandItem>
    </CommandGroup>
  </CommandList>
</Command>
```

### 18. ContextMenu
**Based on:** `radix-ui` (ContextMenu primitive)
**Sub-parts:** ContextMenu, ContextMenuTrigger, ContextMenuContent, ContextMenuItem, ContextMenuCheckboxItem, ContextMenuRadioItem, ContextMenuLabel, ContextMenuSeparator, ContextMenuShortcut, ContextMenuSub, ContextMenuSubTrigger, ContextMenuSubContent

### 19. Dialog
**Based on:** `radix-ui` (Dialog primitive)
**Sub-parts:** Dialog, DialogTrigger, DialogPortal, DialogClose, DialogOverlay, DialogContent, DialogHeader, DialogFooter, DialogTitle, DialogDescription
**Props (DialogContent):** showCloseButton (boolean, default true)
**Features:** Animated overlay, centered modal, close button, keyboard dismiss

### 20. Direction
**Based on:** `@radix-ui/react-direction` (from `radix-ui`)
**Sub-parts:** Direction, DirectionProvider
**Props:** dir ("ltr" | "rtl")
**Purpose:** RTL/LTR direction context for the app

### 21. Drawer
**Based on:** `vaul` (Drawer as DrawerPrimitive)
**Sub-parts:** Drawer, DrawerTrigger, DrawerPortal, DrawerClose, DrawerOverlay, DrawerContent, DrawerHeader, DrawerFooter, DrawerTitle, DrawerDescription
**Directions:** top, bottom, left, right
**Features:** Drag handle (bottom), responsive, scrollable content
**Usage:** `<Drawer><DrawerTrigger>Open</DrawerTrigger><DrawerContent><DrawerHeader><DrawerTitle>Title</DrawerTitle></DrawerHeader>Content</DrawerContent></Drawer>`

### 22. DropdownMenu
**Based on:** `radix-ui` (DropdownMenu primitive)
**Sub-parts:** DropdownMenu, DropdownMenuPortal, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuGroup, DropdownMenuItem, DropdownMenuCheckboxItem, DropdownMenuRadioGroup, DropdownMenuRadioItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuShortcut, DropdownMenuSub, DropdownMenuSubTrigger, DropdownMenuSubContent
**Props (DropdownMenuItem):** inset (boolean), variant ("default" | "destructive")
**Features:** Nested sub-menus, radio groups, checkbox items, keyboard shortcuts
**Usage:**
```tsx
<DropdownMenu>
  <DropdownMenuTrigger>Open</DropdownMenuTrigger>
  <DropdownMenuContent>
    <DropdownMenuLabel>My Account</DropdownMenuLabel>
    <DropdownMenuSeparator />
    <DropdownMenuItem>Profile</DropdownMenuItem>
    <DropdownMenuItem>Settings <DropdownMenuShortcut>⌘S</DropdownMenuShortcut></DropdownMenuItem>
    <DropdownMenuSeparator />
    <DropdownMenuItem variant="destructive">Delete</DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

### 23. Empty
**Standalone, no Radix dependency**
**Sub-parts:** Empty, EmptyIcon, EmptyTitle, EmptyDescription, EmptyActions
**Props:** showIcon, icon, iconClassName, className (all)

### 24. Field
**Standalone, field abstraction**
**Sub-parts:** Field, FieldLabel, FieldDescription, FieldError, FieldControl
**Props:** id, error, required, disabled, className (on Field)

### 25. Form
**Based on:** `react-hook-form` + `radix-ui` (Slot + Label)
**Sub-parts:** Form, FormField, FormItem, FormLabel, FormControl, FormDescription, FormMessage
**Imports:** Controller, FormProvider, useFormContext, useFormState from react-hook-form
**Key hook:** `useFormField()` — returns id, name, error, formItemId, formDescriptionId, formMessageId
**Usage:**
```tsx
const form = useForm({ resolver: zodResolver(schema) })
<Form {...form}>
  <form onSubmit={form.handleSubmit(onSubmit)}>
    <FormField control={form.control} name="username" render={({ field }) => (
      <FormItem>
        <FormLabel>Username</FormLabel>
        <FormControl>
          <Input {...field} />
        </FormControl>
        <FormDescription>Your public display name.</FormDescription>
        <FormMessage />
      </FormItem>
    )} />
  </form>
</Form>
```

### 26. HoverCard
**Based on:** `radix-ui` (HoverCard primitive)
**Sub-parts:** HoverCard, HoverCardTrigger, HoverCardContent
**Props:** openDelay, closeDelay, side, align

### 27. Input
**Standalone, native HTML input**
**Props:** All HTMLInputElement props + className
**Features:** Focus ring, invalid state styling, file input support, selection color

### 28. InputGroup
**Extends Input with grouping**
**Sub-parts:** InputGroup, InputGroupInput, InputGroupText
**Props:** variant, size, className

### 29. InputOTP
**Based on:** `input-otp` (npm)
**Sub-parts:** InputOTP, InputOTPGroup, InputOTPSlot, InputOTPSeparator
**Props:** maxLength, pattern, render, containerClassName
**Usage:** One-time password / verification code input

### 30. Item
**Standalone, list item abstraction**
**Sub-parts:** Item
**Props:** asChild, className

### 31. Kbd
**Standalone, keyboard key display**
**Sub-parts:** Kbd
**Props:** asChild, className
**Renders as:** `<kbd>` element styled as keyboard key

### 32. Label
**Based on:** `radix-ui` (Label primitive)
**Sub-parts:** Label
**Props:** htmlFor, className

### 33. Menubar
**Based on:** `radix-ui` (Menubar primitive)
**Sub-parts:** Menubar, MenubarMenu, MenubarTrigger, MenubarContent, MenubarItem, MenubarCheckboxItem, MenubarRadioItem, MenubarLabel, MenubarSeparator, MenubarShortcut, MenubarSub, MenubarSubTrigger, MenubarSubContent

### 34. NativeSelect
**Standalone, native HTML `<select>`**
**Sub-parts:** NativeSelect
**Props:** All HTMLSelectElement props, children (as `<option>` elements)
**Styling:** Tailwind-styled native select with chevron icon

### 35. NavigationMenu
**Based on:** `radix-ui` (NavigationMenu primitive)
**Sub-parts:** NavigationMenu, NavigationMenuList, NavigationMenuItem, NavigationMenuTrigger, NavigationMenuContent, NavigationMenuLink, NavigationMenuIndicator, NavigationMenuViewport
**Features:** Hover-to-expand, viewport animation, indicator

### 36. Pagination
**Standalone, no Radix dependency**
**Sub-parts:** Pagination, PaginationContent, PaginationItem, PaginationLink, PaginationPrevious, PaginationNext, PaginationEllipsis
**Props:** size, active (on PaginationLink)

### 37. Popover
**Based on:** `radix-ui` (Popover primitive)
**Sub-parts:** Popover, PopoverTrigger, PopoverContent, PopoverAnchor
**Props:** side, align, sideOffset

### 38. Progress
**Based on:** `radix-ui` (Progress primitive)
**Sub-parts:** Progress
**Props:** value (0-100), max, className

### 39. RadioGroup
**Based on:** `radix-ui` (RadioGroup primitive)
**Sub-parts:** RadioGroup, RadioGroupItem, RadioGroupIndicator
**Props:** value, onValueChange, defaultValue, orientation

### 40. Resizable
**Based on:** `react-resizable-panels`
**Sub-parts:** ResizablePanelGroup, ResizablePanel, ResizableHandle
**Props:** direction ("horizontal" | "vertical"), defaultSize, minSize, maxSize

### 41. ScrollArea
**Based on:** `radix-ui` (ScrollArea primitive)
**Sub-parts:** ScrollArea, ScrollBar
**Props:** orientation, type ("auto" | "always" | "scroll" | "hover")

### 42. Select
**Based on:** `radix-ui` (Select primitive)
**Sub-parts:** Select, SelectGroup, SelectValue, SelectTrigger, SelectContent, SelectLabel, SelectItem, SelectSeparator, SelectScrollUpButton, SelectScrollDownButton
**Props (SelectTrigger):** size ("sm" | "default")
**Features:** Scroll buttons, item indicator (checkmark), popper positioning
**Usage:**
```tsx
<Select>
  <SelectTrigger>
    <SelectValue placeholder="Select a fruit" />
  </SelectTrigger>
  <SelectContent>
    <SelectItem value="apple">Apple</SelectItem>
    <SelectItem value="banana">Banana</SelectItem>
  </SelectContent>
</Select>
```

### 43. Separator
**Based on:** `radix-ui` (Separator primitive)
**Sub-parts:** Separator
**Props:** orientation ("horizontal" | "vertical"), decorative

### 44. Sheet
**Based on:** `radix-ui` (Dialog primitive)
**Sub-parts:** Sheet, SheetTrigger, SheetClose, SheetContent, SheetHeader, SheetFooter, SheetTitle, SheetDescription
**Props (SheetContent):** side ("top" | "bottom" | "left" | "right"), showCloseButton
**Usage:** Mobile-friendly slide-in panel

### 45. Sidebar
**Standalone, built with Radix Slot, Tooltip, Sheet, Button, Input, Separator, Skeleton**
**Sub-parts (22 total):** SidebarProvider, Sidebar, SidebarTrigger, SidebarRail, SidebarInset, SidebarInput, SidebarHeader, SidebarFooter, SidebarContent, SidebarGroup, SidebarGroupLabel, SidebarGroupAction, SidebarGroupContent, SidebarMenu, SidebarMenuItem, SidebarMenuButton, SidebarMenuAction, SidebarMenuBadge, SidebarMenuSkeleton, SidebarMenuSub, SidebarMenuSubItem, SidebarMenuSubButton, SidebarSeparator
**Props:** side ("left" | "right"), variant ("sidebar" | "floating" | "inset"), collapsible ("offcanvas" | "icon" | "none")
**Context:** useSidebar() hook
**Features:** Keyboard shortcut (Ctrl/Cmd+B), cookie persistence, responsive (Sheet on mobile), tooltip on collapse

### 46. Skeleton
**Standalone, no Radix dependency**
**Sub-parts:** Skeleton
**Props:** className
**Usage:** `<Skeleton className="h-4 w-[250px]" />`

### 47. Slider
**Based on:** `radix-ui` (Slider primitive)
**Sub-parts:** Slider, SliderTrack, SliderRange, SliderThumb
**Props:** defaultValue, value, onValueChange, min, max, step, orientation

### 48. Sonner
**Based on:** `sonner` (toast library)
**Sub-parts:** Toaster
**Props:** All Sonner ToasterProps
**Icons:** Custom success/info/warning/error/loading icons from lucide-react
**Features:** Theme-aware (next-themes), CSS variable styling
**Usage:** `<Toaster />` + `toast("Event has been created.")`

### 49. Spinner
**Standalone, SVG-based**
**Sub-parts:** Spinner
**Props:** size ("sm" | "default" | "lg"), className
**Usage:** `<Spinner size="lg" />`

### 50. Switch
**Based on:** `radix-ui` (Switch primitive)
**Sub-parts:** Switch, SwitchThumb
**Props:** checked, onCheckedChange, disabled

### 51. Table
**Standalone, native HTML table**
**Sub-parts:** Table, TableHeader, TableBody, TableFooter, TableHead, TableRow, TableCell, TableCaption
**Props:** className only (all)
**Features:** Hover states, selection styling, responsive overflow

### 52. Tabs
**Based on:** `radix-ui` (Tabs primitive)
**Sub-parts:** Tabs, TabsList, TabsTrigger, TabsContent
**Props:** defaultValue, value, onValueChange, orientation

### 53. Textarea
**Standalone, native HTML textarea**
**Sub-parts:** Textarea
**Props:** All HTMLTextAreaElement props + className

### 54. Toggle
**Based on:** `radix-ui` (Toggle primitive)
**Sub-parts:** Toggle
**Variants:** default, outline
**Sizes:** default, sm, lg
**Props:** variant, size, pressed, onPressedChange, asChild
**Exports:** Toggle, toggleVariants

### 55. ToggleGroup
**Based on:** `radix-ui` (ToggleGroup primitive)
**Sub-parts:** ToggleGroup, ToggleGroupItem
**Variants:** default, outline
**Sizes:** default, sm, lg
**Props:** type ("single" | "multiple"), value, onValueChange, variant, size

### 56. Tooltip
**Based on:** `radix-ui` (Tooltip primitive)
**Sub-parts:** TooltipProvider, Tooltip, TooltipTrigger, TooltipContent
**Props (TooltipProvider):** delayDuration (default 0), skipDelayDuration
**Props (TooltipContent):** side, align, sideOffset, showArrow (boolean)

## Key Dependencies
| Package | Usage |
|---------|-------|
| `radix-ui` | All interactive primitives (dialog, dropdown, select, etc.) |
| `class-variance-authority` | Component variants (Button, Badge, Toggle, SidebarMenuButton) |
| `clsx` + `tailwind-merge` | `cn()` utility for className merging |
| `react-hook-form` | Form component integration |
| `zod` | Schema validation (used with Form) |
| `lucide-react` | Icon library (used across all components) |
| `cmdk` | Command palette (Command component) |
| `recharts` | Chart component |
| `react-day-picker` | Calendar component |
| `embla-carousel-react` | Carousel component |
| `vaul` | Drawer component |
| `sonner` | Toast notifications |
| `input-otp` | OTP input |
| `react-resizable-panels` | Resizable panels |
| `next-themes` | Theme management (used by Toaster) |
| `tailwindcss` | Required base dependency |
