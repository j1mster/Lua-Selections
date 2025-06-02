# lua-selections

**`lua-selections`** is a chaotic little Lua terminal UI library that lets you mess with your users using cute arrow-key menus, prompts, and text input. ANSI colors included for extra spice.

---

## 🔧 Features

* Arrow key navigation (↑ ↓ ← →)
* Y-only or full X/Y grid-style options
* Text input prompts
* Colored output with ANSI escapes
* Fully callback-based flow
* Refresh-based screen system (no `print()`!!)

---

## 🚀 Getting Started

```lua
local selections = require("lua-selections")
```

> ✅ Requires Lua + `luv` (libuv bindings)

---

## 📋 Example Usage

### 🗣️ Text Input Prompt

```lua
selections:prompt("What's your name?", function(name)
    selections:write("Hello, " .. name)
end)
```

### 🔢 Y-Only Menu Prompt

```lua
selections:prompt("Pick a number:", {
    "One",
    "Two",
    "Three"
}, function(choice)
    selections:write("You picked: " .. choice)
end)
```

### 🎯 X/Y Grid Prompt

```lua
selections:prompt("Choose your fighter:", {
    Y = {"Strength", "Speed", "Magic"},
    X = {
        {"Buff Man", "Dad Bod"},
        {"Fast Kid", "Blur"},
        {"Wizard", "Witch"}
    }
}, function(choice)
    selections:write("You chose: " .. choice)
end)
```

---

## 💅 Output Like You Mean It

```lua
-- This works ✅
selections:write("Hi there!")

-- This WILL be cleared ❌
print("Don't do this")
io.write("Stop doing this too")
```

---

## 🎨 ANSI Color Time

```lua
selections:write(selections.color("This is red.", "red"))
```

Available colors:

```
black, red, green, yellow, blue,
magenta, cyan, white,
pink, orange, brightBlue
```

---

## 🧠 Prompt Signature

```lua
selections:prompt(promptText, options, callback)
```

### Y-only menu:

```lua
{"Option 1", "Option 2", "Option 3"}
```

### X/Y menu:

```lua
{
    Y = {"Row 1", "Row 2", "Row 3"},
    X = {
        {"A", "B"},
        {"C", "D"},
        {"E", "F"}
    }
}
```

---

## ⌨️ Keybindings

| Key     | Action             |
| ------- | ------------------ |
| ↑ ↓ ← → | Navigate           |
| Enter   | Confirm selection  |
| Ctrl+C  | Cancel / Exit loop |
| 1–9     | Jump to Y row      |

---

## 🧼 Clear Screen

```lua
selections.clear()
```

---

## 📦 Sample Output

```
Choose a beverage:
 [1] Water    Juice   Milk
 [2] Soda     Tea     Coffee

Use arrow keys to navigate.
```

---

## 📝 License

GNU GENERAL PUBLIC LICENSE

---

## 🤝 Contributing

PRs welcome! Add cursed features like mouse support, input remapping, emoji-based menus, or terminal chaos and toss in a pull request.
