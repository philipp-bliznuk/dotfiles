local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 0 -- follows tabstop
opt.expandtab = true
opt.breakindent = true -- wrapped lines follow indent level
-- NOTE: no smartindent - arborist sets indentexpr per buffer via treesitter
-- the runtime ftplugin would set shiftwidth=4 softtabstop=4 over the ts=2 autocmd
vim.g.markdown_recommended_style = 0

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- live preview of :s substitutions

-- UI
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes:2"
opt.wrap = false
opt.linebreak = true -- when wrap is on (per-ft), break at word boundaries
opt.smoothscroll = true -- smooth scroll for wrapped lines
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.showmode = false -- statusline handles this
opt.pumheight = 15
opt.cmdheight = 0 -- hide cmdline when not in use
opt.laststatus = 3 -- global statusline (one for all windows)
opt.splitkeep = "screen" -- keep text stable on split
opt.winborder = "rounded" -- global border for all floating windows (0.11+)

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.writebackup = false

-- Timing
opt.updatetime = 250
opt.timeoutlen = 400

-- Editing
opt.mouse = "a"
opt.completeopt = { "menu", "menuone", "noselect" } -- native fallback (<C-n> with no blink menu open)
opt.confirm = true -- confirm before closing unsaved buffer
opt.virtualedit = "block" -- allow cursor past EOL in visual block mode
opt.jumpoptions:append("view") -- restore view on jumplist navigation

-- Command line
opt.wildmode = "longest:full,full" -- better cmdline completion
opt.shortmess:append("sSI") -- no intro, no "search hit BOTTOM", no native [1/5] count (statusline shows it)

-- Word boundaries
opt.iskeyword:append("-") -- treat dash as part of word (kebab-case)

-- Diff
opt.diffopt:append("linematch:60") -- better inline diff

-- Fillchars for cleaner UI
opt.fillchars = {
  eob = " ", -- hide ~ on empty lines
  fold = " ",
  diff = "╱",
}

-- Folds (treesitter-powered via arborist)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99 -- start with all folds open

-- Grep: nvim picks rg on its own, but with -uu (ignored and hidden files
-- too); this one respects .gitignore and is smart-case
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
end
