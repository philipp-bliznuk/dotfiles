import os
import re
from pathlib import Path

config.load_autoconfig()

# --- PATH fix for GUI-launched instances (Raycast/Dock/Spotlight) ---
# macOS GUI apps inherit minimal PATH; add homebrew so userscripts find binaries
os.environ["PATH"] = "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:" + os.environ.get(
    "PATH", "/usr/bin:/bin:/usr/sbin:/sbin"
)

# --- Theme palette loading ---
# GUI apps don't inherit shell env vars — parse theme directly from files

DOTFILES = Path(__file__).resolve().parent.parent

# Read theme name from .zshenv
_theme = "catppuccin-mocha"
_zshenv = DOTFILES / ".zshenv"
if _zshenv.exists():
    for _line in _zshenv.read_text().splitlines():
        _m = re.match(r'^export THEME="(.+)"', _line)
        if _m:
            _theme = _m.group(1)
            break

# Parse palette from theme.zsh
_raw = {}
_theme_file = DOTFILES / "themes" / _theme / "theme.zsh"
if _theme_file.exists():
    for _line in _theme_file.read_text().splitlines():
        _m = re.match(r'\s+(\w+)\s+"(#[0-9a-fA-F]{6})"', _line)
        if _m:
            _raw[_m.group(1)] = _m.group(2)

# Per-color fallbacks (catppuccin-mocha defaults)
_MOCHA = {
    "rosewater": "#f5e0dc",
    "flamingo": "#f2cdcd",
    "pink": "#f5c2e7",
    "mauve": "#cba6f7",
    "red": "#f38ba8",
    "maroon": "#eba0ac",
    "peach": "#fab387",
    "yellow": "#f9e2af",
    "green": "#a6e3a1",
    "teal": "#94e2d5",
    "sky": "#89dceb",
    "sapphire": "#74c7ec",
    "blue": "#89b4fa",
    "lavender": "#b4befe",
    "text": "#cdd6f4",
    "subtext1": "#bac2de",
    "subtext0": "#a6adc8",
    "overlay2": "#9399b2",
    "overlay1": "#7f849c",
    "overlay0": "#6c7086",
    "surface2": "#585b70",
    "surface1": "#45475a",
    "surface0": "#313244",
    "base": "#1e1e2e",
    "mantle": "#181825",
    "crust": "#11111b",
}


def p(key):
    """Get palette color by key, falling back to mocha default."""
    return _raw.get(key, _MOCHA[key])


# --- Colors ---

# Completion
c.colors.completion.fg = p("text")
c.colors.completion.odd.bg = p("mantle")
c.colors.completion.even.bg = p("base")
c.colors.completion.category.fg = p("blue")
c.colors.completion.category.bg = p("base")
c.colors.completion.category.border.top = p("base")
c.colors.completion.category.border.bottom = p("base")
c.colors.completion.item.selected.fg = p("text")
c.colors.completion.item.selected.bg = p("surface1")
c.colors.completion.item.selected.border.top = p("surface1")
c.colors.completion.item.selected.border.bottom = p("surface1")
c.colors.completion.item.selected.match.fg = p("peach")
c.colors.completion.match.fg = p("peach")
c.colors.completion.scrollbar.fg = p("surface2")
c.colors.completion.scrollbar.bg = p("base")

# Downloads
c.colors.downloads.bar.bg = p("base")
c.colors.downloads.start.fg = p("base")
c.colors.downloads.start.bg = p("blue")
c.colors.downloads.stop.fg = p("base")
c.colors.downloads.stop.bg = p("green")
c.colors.downloads.error.fg = p("red")

# Hints
c.colors.hints.fg = p("base")
c.colors.hints.bg = p("peach")
c.colors.hints.match.fg = p("surface1")
c.colors.keyhint.fg = p("text")
c.colors.keyhint.suffix.fg = p("peach")
c.colors.keyhint.bg = p("base")

# Messages
c.colors.messages.error.fg = p("base")
c.colors.messages.error.bg = p("red")
c.colors.messages.error.border = p("red")
c.colors.messages.warning.fg = p("base")
c.colors.messages.warning.bg = p("yellow")
c.colors.messages.warning.border = p("yellow")
c.colors.messages.info.fg = p("text")
c.colors.messages.info.bg = p("base")
c.colors.messages.info.border = p("base")

# Prompts
c.colors.prompts.fg = p("text")
c.colors.prompts.border = p("surface0")
c.colors.prompts.bg = p("mantle")
c.colors.prompts.selected.fg = p("text")
c.colors.prompts.selected.bg = p("surface1")

# Statusbar
c.colors.statusbar.normal.fg = p("text")
c.colors.statusbar.normal.bg = p("base")
c.colors.statusbar.insert.fg = p("base")
c.colors.statusbar.insert.bg = p("green")
c.colors.statusbar.passthrough.fg = p("base")
c.colors.statusbar.passthrough.bg = p("mauve")
c.colors.statusbar.private.fg = p("base")
c.colors.statusbar.private.bg = p("flamingo")
c.colors.statusbar.command.fg = p("text")
c.colors.statusbar.command.bg = p("base")
c.colors.statusbar.command.private.fg = p("text")
c.colors.statusbar.command.private.bg = p("base")
c.colors.statusbar.caret.fg = p("base")
c.colors.statusbar.caret.bg = p("mauve")
c.colors.statusbar.caret.selection.fg = p("base")
c.colors.statusbar.caret.selection.bg = p("mauve")
c.colors.statusbar.progress.bg = p("blue")
c.colors.statusbar.url.fg = p("text")
c.colors.statusbar.url.error.fg = p("red")
c.colors.statusbar.url.hover.fg = p("sky")
c.colors.statusbar.url.success.http.fg = p("teal")
c.colors.statusbar.url.success.https.fg = p("green")
c.colors.statusbar.url.warn.fg = p("yellow")

# Tabs
c.colors.tabs.bar.bg = p("crust")
c.colors.tabs.indicator.start = p("blue")
c.colors.tabs.indicator.stop = p("green")
c.colors.tabs.indicator.error = p("red")
c.colors.tabs.odd.fg = p("subtext1")
c.colors.tabs.odd.bg = p("mantle")
c.colors.tabs.even.fg = p("subtext1")
c.colors.tabs.even.bg = p("crust")
c.colors.tabs.pinned.odd.fg = p("green")
c.colors.tabs.pinned.odd.bg = p("mantle")
c.colors.tabs.pinned.even.fg = p("green")
c.colors.tabs.pinned.even.bg = p("crust")
c.colors.tabs.pinned.selected.odd.fg = p("text")
c.colors.tabs.pinned.selected.odd.bg = p("surface0")
c.colors.tabs.pinned.selected.even.fg = p("text")
c.colors.tabs.pinned.selected.even.bg = p("surface0")
c.colors.tabs.selected.odd.fg = p("text")
c.colors.tabs.selected.odd.bg = p("surface0")
c.colors.tabs.selected.even.fg = p("text")
c.colors.tabs.selected.even.bg = p("surface0")

# Context menu
c.colors.contextmenu.disabled.fg = p("overlay0")
c.colors.contextmenu.disabled.bg = p("mantle")
c.colors.contextmenu.menu.fg = p("text")
c.colors.contextmenu.menu.bg = p("mantle")
c.colors.contextmenu.selected.fg = p("text")
c.colors.contextmenu.selected.bg = p("surface1")

# Webpage
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.bg = p("base")

# --- General settings ---

c.auto_save.session = True
c.session.default_name = "default"

# Search engines
c.url.default_page = "https://search.brave.com"
c.url.start_pages = ["https://search.brave.com"]
c.url.searchengines = {
    "DEFAULT": "https://search.brave.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "gh": "https://github.com/search?q={}&type=repositories",
}

# Editor (opens in tmux pane alongside qutebrowser)
c.editor.command = ["tmux", "new-window", "nvim", "+{line}", "--", "{file}"]

# Fonts
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.fonts.default_size = "11pt"

# Tabs
c.tabs.position = "top"
c.tabs.show = "multiple"
c.tabs.last_close = "default-page"
c.tabs.title.format = "{audio}{current_title}"

# Scrolling
c.scrolling.smooth = True

# --- Privacy ---

c.content.geolocation = False
c.content.notifications.enabled = False
c.content.autoplay = False
c.content.canvas_reading = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"

# Adblock: network-level (host blocking + Brave Rust adblocker)
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
]
c.content.blocking.hosts.lists = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"]

# --- Downloads ---

c.downloads.location.directory = "~/Downloads"
c.downloads.location.prompt = False
c.downloads.position = "bottom"

# --- Hints ---

c.hints.chars = "asdfghjkl"
c.hints.uppercase = True

# --- Keybindings ---

# 1Password fill
config.bind(",l", "spawn --userscript qute-1pass")

# fzf integrations
config.bind(",h", "spawn --userscript qute-fzf-history")
config.bind(",t", "spawn --userscript qute-fzf-tabs")
config.bind(",b", "spawn --userscript qute-fzf-bookmarks")

# Utilities
config.bind(",m", "hint links spawn mpv {hint-url}")
config.bind(",p", "open -p")
config.bind(",d", "config-cycle content.user_stylesheets [] ['{}/darkmode.css']".format(DOTFILES / "qutebrowser"))

# Tab management
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("x", "tab-close")
config.bind("X", "undo")
config.bind("<Ctrl-Shift-Tab>", "tab-prev")
config.bind("<Ctrl-Tab>", "tab-next")
