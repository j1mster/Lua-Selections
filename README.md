# lua-selections

**`lua-selections`** is a simple Lua terminal UI library for Lua that allows you to prompt users for input via keyboard-navigable menus. Supports text input, arrow-key selection, and 2D option grids.

---

## 🔧 Features

- Arrow key navigation (↑ ↓ ← →)
- Multi-level options (Y/X grid support)
- Text input prompt
- ANSI-colored output
- Simple integration
- Fully callback-based

---

## 🚀 Getting Started

```lua
local selections = require("lua-selections")
```

> ✅ Requires Lua + `luv` (libuv bindings).

---

## 📋 Basic Usage

### Simple Text Prompt

```lua
selections:prompt("What's your name?", function(name)
    selections:write("Hello, " .. name)
end)
```

---

### Single-Dimensional Selection

```lua
selections:prompt("Choose an option:", {
    "Yes", "No", "Maybe"
}, function(choice)
    selections:write("You picked: " .. choice)
end)
```

---

### Two-Dimensional Menu (Y/X Grid)

```lua
selections:prompt("Pick a tile:",
    {"Row 1", "Row 2", "Row 3"},
    {
        {"A", "B", "C"},
        {"D", "E", "F"},
        {"G", "H", "I"}
    },
    function(choice)
        selections:write("You picked: " .. choice)
    end
)
```

---

## ⚠️ Output Warning

Because `lua-selections` **uses a refresh system that clears and redraws the screen**, you **must use**:

```lua
selections:write("Text here")
```

**Do not use** `print()` or `io.write()` — they will be wiped on refresh.

---

## 🎨 Colored Text

```lua
selections:write(selections.color("Hello in red", "red"))
```

Supported colors:

```
black, red, green, yellow, blue,
magenta, cyan, white,
pink, orange, brightBlue
```

---

## 🧠 Prompt Structure

```lua
selections:prompt(
    name,         -- string
    optionsY?,    -- table of vertical options (rows)
    optionsX?,    -- table of sub-options for each row
    callback      -- function(selectedName)
)
```

### Example

```lua
selections:prompt("Settings:",
    {"Graphics", "Audio"},
    {
        {"Low", "High"},
        {"Mute", "Medium", "Max"}
    },
    function(choice)
        selections:write("You picked: " .. choice)
    end
)
```

---

## ⌨️ Keybindings

| Key        | Action                 |
|------------|------------------------|
| Arrow Keys | Move selection         |
| Enter      | Confirm                |
| Ctrl+C     | Exit / Stop input loop |
| 1–9        | Jump to row (Y option) |

---

## 🧼 Clearing Terminal

You can manually clear the terminal:

```lua
selections.clear()
```

---

## 📦 Example Output

```
Choose a color:
 [1] Red
 [2] Green
 [3] Blue

Use arrow keys to navigate.
```

---

## 📝 License

GNU GENERAL PUBLIC LICENSE
---

## 💬 Notes

- You can call `:prompt()` again even if a prompt is active — the old one will be closed automatically.
- The selected result is passed to your callback as a string (`option.name`).

---

## 🤝 Contributing

PRs and improvements welcome! If you add features like mouse input, resizing, or key remapping, feel free to open a pull request.
