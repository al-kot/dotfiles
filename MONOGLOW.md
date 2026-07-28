# Mono Glow — Color Scheme Reference

## Palette

All colors flow from these core values. Change the accent color by updating the hex values below
and the corresponding xterm-256color approximations.

### Core Colors

| Token | Hex | xterm | Role |
|-------|-----|-------|------|
| `glow` | `#98BB6C` | 150 | Primary accent (olive green) |
| `sage` | `#76946A` | 108 | Secondary accent (sage green) |
| `muted` | `#727169` | 242 | Muted text, comments, strings |
| `red` | `#663333` | 95 | Muted red-brown (errors, deletions) |
| `warm` | `#b4a87a` | — | Muted warm yellow (warnings) |
| `bg` | `#121212` | 233 | Background (near black) |
| `fg` | `#cccccc` | 188 | Foreground (light gray) |
| `gray2` | `#191919` | 234 | Slightly lighter than bg |
| `gray3` | `#2a2a2a` | 235 | Selection backgrounds, inactive borders |
| `gray4` | `#444444` | 238 | Borders, dim elements |
| `gray5` | `#555555` | 240 | Dim text |
| `gray6` | `#7a7a7a` | 243 | Muted text, secondary UI |
| `gray7` | `#aaaaaa` | 248 | Lighter text |
| `gray8` | `#cccccc` | 252 | Same as fg |

## Where Colors Are Used

### 1. Neovim — `~/.config/nvim/lua/plugins.lua`

```lua
require('monoglow').setup({
    on_colors = function(colors)
        colors.glow = '#98BB6C'           -- operators, search, PmenuSel, match paren
        colors.blue1 = '#76946A'           -- was blue, now sage
        colors.blue2 = '#76946A'           -- was blue, now sage
        colors.syntax.string = '#727169'   -- strings
        colors.light_red = '#663333'       -- diagnostics, errors
        colors.git.delete = '#663333'      -- gitsigns delete
        colors.git.add = '#76946A'         -- gitsigns add
    end,
    on_highlights = function(highlights, colors)
        -- strip background from inline diagnostics
        highlights.DiagnosticVirtualTextError = { fg = colors.error }
        highlights.DiagnosticVirtualTextWarn  = { fg = colors.warning }
        highlights.DiagnosticVirtualTextHint  = { fg = colors.hint }
        highlights.DiagnosticVirtualTextInfo  = { fg = colors.info }
        highlights.DiagnosticVirtualTextOk    = { fg = colors.ok }
    end,
})
```

**To change accent:** update `colors.glow` and `colors.blue1/blue2`.
**To change git signs:** update `colors.git.add` / `colors.git.delete`.

### 2. Kitty — `~/.config/kitty/monoglow.conf`

```
active_border_color #98BB6C    # accent border

color0  #2a2a2a     # black
color8  #4a4a4a     # bright black
color1  #663333     # red
color9  #885555     # bright red
color2  #98BB6C     # green
color10 #66ffad     # bright green
color3  #b4b4b4     # yellow
color11 #dddddd     # bright yellow
color4  #7a7a7a     # blue
color12 #aaaaaa     # bright blue
color5  #76946A     # magenta
color13 #879aad     # bright magenta
color6  #76946A     # cyan
color14 #49c4c4     # bright cyan
color7  #f1f1f1     # white
color15 #ffffff     # bright white
```

**To change accent:** update `color2`, `color5`, `color6`, `active_border_color`.
**To change red:** update `color1`, `color9`.

### 3. lsd — `~/.config/lsd/colors.yaml`

```yaml
user: 150       # glow  (#98BB6C)
group: 108      # sage  (#76946A)
permission:
  read: 242     # muted (#727169)
  write: 150    # glow
  exec: 108     # sage
  no-access: 95 # red   (#663333)
date:
  hour-old: 150 # glow
  day-old: 108  # sage
  older: 243    # gray6 (#7a7a7a)
size:
  none: 243     # gray6
  small: 150    # glow
  medium: 108   # sage
  large: 95     # red
tree-edge: 235  # gray3 (#2a2a2a)
```

**To change accent:** replace `150` with new xterm color, and `108` with new secondary.
**To change red:** replace `95`.

### 4. tmux — `~/.tmux.conf`

```
set -g @fg     "#7a7a7a"   # gray6 — status text
set -g @bg     "#121212"   # bg — status bar background
set -g @accent "#98BB6C"   # glow — active border, current window, prefix
set -g @muted  "#727169"   # muted — available for custom use
set -g @gray3  "#2a2a2a"   # gray3 — inactive pane borders
```

Used in:
- `status-right` — session name badge `#[bg=#{@accent},fg=#{@bg}]`
- `window-status-current-format` — `#[bg=#{@accent},fg=#{@bg}]`
- `pane-active-border-style` — `fg="#{@accent}"`
- `pane-border-style` — `fg="#{@gray3}"`

**To change accent:** update `@accent` and `@bg` (for contrast on accent).

### 5. pi agent — `~/.pi/agent/themes/monoglow.json`

```json
{
  "vars": {
    "glow": "#98BB6C",
    "sage": "#76946A",
    "muted": "#727169",
    "red": "#663333",
    "fg": "#cccccc",
    "gray4": "#444444",
    "gray6": "#7a7a7a"
  },
  "colors": {
    "accent": "glow",
    "borderAccent": "glow",
    "success": "sage",
    "error": "red",
    "warning": "warm",
    "mdHeading": "glow",
    "mdLink": "glow",
    "syntaxKeyword": "glow",
    "syntaxFunction": "glow",
    "syntaxType": "glow",
    "syntaxOperator": "glow",
    "thinkingHigh": "glow",
    "thinkingXhigh": "red",
    "thinkingMax": "red"
  }
}
```

**To change accent:** update `vars.glow` and `vars.sage` — all tokens referencing them follow.

### 6. fzf — `~/.zshrc`

```
color00 #121212    bg
color01 #663333    red
color02 #76946A    green
color03 #b4a87a    yellow
color04 #7a7a7a    blue
color05 #727169    magenta
color06 #98BB6C    cyan
color07 #cccccc    fg
color08 #444444    bright black
color09 #663333    bright red
color0A #98BB6C    bright green
color0B #b4a87a    bright yellow
color0C #76946A    bright blue
color0D #727169    bright magenta
color0E #76946A    bright cyan
color0F #aaaaaa    bright white
selection #2a2a2a  selection bg
```

**To change accent:** update `color02`, `color06`, `color0A`, `color0C`, `color0E`.

### 7. Quickshell — `~/.config/quickshell/shell.qml`

```javascript
colors: ({
    fg: {
        normal: "#cccccc",   // fg — focused workspace
        inactive: "#7a7a7a"  // gray6 — unfocused workspace
    }
})
```

**To change accent:** update `fg.normal`.

## Changing the Accent Color — Quick Guide

Say you want to switch from olive green (`#98BB6C`) to a warm orange (`#d4a56c`):

1. **Pick new colors** — choose a primary accent and a secondary accent, plus xterm-256color
   approximations (use `python3` to find closest matches).

2. **Update these files:**

   | File | What to change |
   |------|---------------|
   | `~/.config/nvim/lua/plugins.lua` | `colors.glow`, `colors.blue1`, `colors.blue2` |
   | `~/.config/kitty/monoglow.conf` | `color2`, `color5`, `color6`, `active_border_color` |
   | `~/.config/lsd/colors.yaml` | 150 → new xterm, 108 → new xterm |
   | `~/.tmux.conf` | `@accent` |
   | `~/.pi/agent/themes/monoglow.json` | `vars.glow`, `vars.sage` |
   | `~/.zshrc` | `color02`, `color06`, `color0A`, `color0C`, `color0E` |

3. **Reload:**
   - Neovim: restart or `:colorscheme monoglow`
   - Kitty: restart
   - tmux: `<prefix>r`
   - pi: hot-reloads automatically
   - fzf: new terminal
   - quickshell: restart the panel

### Finding xterm-256color Approximations

```python
python3 -c "
def xterm_rgb(n):
    if n < 16: return [(0,0,0),(128,0,0),(0,128,0),(128,128,0),(0,0,128),(128,0,128),(0,128,128),(192,192,192),(128,128,128),(255,0,0),(0,255,0),(255,255,0),(0,0,255),(255,0,255),(0,255,255),(255,255,255)][n]
    if n < 232:
        n -= 16
        return (n//36*51, n//6%6*51, n%6*51)
    v = (n-232)*10+8
    return (v,v,v)

def closest(r, g, b):
    best = min(range(256), key=lambda i: sum((a-b)**2 for a,b in zip((r,g,b), xterm_rgb(i))))
    return best, xterm_rgb(best)

# Example: find closest to #d4a56c
r, g, b = 0xd4, 0xa5, 0x6c
idx, rgb = closest(r, g, b)
print(f'#{r:02x}{g:02x}{b:02x} -> xterm {idx} (RGB {rgb})')
"
```

## Quick Reference — xterm-256color Mappings

| Hex | xterm | Used in |
|-----|-------|---------|
| `#121212` | 233 | bg |
| `#191919` | 234 | gray2 |
| `#2a2a2a` | 235 | gray3, selection, tree-edge |
| `#444444` | 238 | gray4, borders |
| `#555555` | 240 | gray5, dim |
| `#663333` | 95 | red |
| `#727169` | 242 | muted |
| `#7a7a7a` | 243 | gray6 |
| `#76946A` | 108 | sage |
| `#98BB6C` | 150 | glow |
| `#aaaaaa` | 248 | gray7 |
| `#cccccc` | 188 | fg |