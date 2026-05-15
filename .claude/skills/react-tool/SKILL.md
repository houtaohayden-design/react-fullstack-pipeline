---
name: react-tool
description: Use when building React UI components or pages, creating frontend interfaces, or writing any React code. Checks knowledge base (animal-island-ui, react-bits, trained repos) for applicable components before writing custom code. Use when user asks to build React UI, frontend, component, or page.
---

# React Frontend Tool

## Overview

Before writing any React UI code, check the knowledge base for existing components that can be reused, combined, or styled. Never write custom animation or UI component from scratch without first checking what's available.

## Knowledge Sources (check in this order)

1. **react-bits** — animation/motion layer: text animations, backgrounds, scroll effects, interactive components
2. **animal-island-ui** — 动森风格 base components: Button, Card, Modal, Input, etc. (ONLY when user asks for 动物森友会/animal-island/可爱圆润风格)
3. **Trained repos** — user-provided GitHub component libraries (`knowledge/registry.json` → `trained` array)

## Workflow

```
User asks for React UI
  → Is it 动森/Animal Island style?
    → YES: Start with animal-island-ui components as base
    → NO: Start with standard React/HTML
  → Need animations/motion?
    → Check react-bits FIRST (110+ components)
  → Check registry.json trained repos for matching components
  → Synthesize: pick best components from each source
  → Write code
```

## Component Selection Priority

| Priority | Source | When |
|----------|--------|------|
| 1 | Trained repos | User's own preferred libraries |
| 2 | react-bits | Any animation, motion, or visual effect |
| 3 | animal-island-ui | Only when 动森风格 explicitly requested |
| 4 | Custom | Only when nothing above fits |

## Quick Reference

### react-bits categories (check first for any animation)
- Text Animations (~23): SplitText, BlurText, TrueFocus, typewriter effects
- Animations (~30): FadeContent, scroll-triggered, hover, cursor effects
- Components (~34): Nav menus, cards, carousels, galleries, docks
- Backgrounds (~40): Particles, shaders, noise, gradients, grid

### animal-island-ui components (only when 动森风格)
- Interactive: Button, Input, Switch, Modal, Select, Checkbox, Tabs, Collapse
- Display: Card (13 colors), Icon (10), Time, Phone, Footer, Divider
- Effect: Cursor, Typewriter, CodeBlock

### Trained repos
Check `D:\Claude Code\react-frontend-tool\knowledge\registry.json` for full list.
Each trained repo has API docs at `knowledge/repos/<slug>/api.md`.

## Rules

- Never write custom animation without checking react-bits first
- Never write custom UI component without checking trained repos first
- animal-island-ui is ONLY for 动森风格 — don't suggest it for general React projects
- When combining libraries, import only what's needed (tree-shaking)
- Always check component dependencies before use (GSAP, Motion, three.js, ogl)
