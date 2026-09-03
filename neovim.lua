-- EREBUS — Primordial Darkness
-- Omarchy Neovim

vim.cmd([[
  highlight Normal guibg=#08090A guifg=#D6D3CE
  highlight NormalFloat guibg=#111315 guifg=#D6D3CE

  highlight CursorLine guibg=#111315
  highlight LineNr guifg=#77746F
  highlight CursorLineNr guifg=#B52A32

  highlight Visual guibg=#8B1E24 guifg=#FFFFFF

  highlight Search guibg=#8B1E24 guifg=#FFFFFF
  highlight IncSearch guibg=#B52A32 guifg=#08090A

  highlight StatusLine guibg=#111315 guifg=#D6D3CE
  highlight StatusLineNC guibg=#08090A guifg=#77746F

  highlight VertSplit guifg=#292B2E
  highlight WinSeparator guifg=#292B2E

  highlight Pmenu guibg=#111315 guifg=#D6D3CE
  highlight PmenuSel guibg=#8B1E24 guifg=#FFFFFF

  highlight Comment guifg=#77746F
  highlight Keyword guifg=#B52A32
  highlight Function guifg=#D6D3CE
  highlight String guifg=#849477
  highlight Number guifg=#C4A66B
  highlight Constant guifg=#8A6F7D
]])

vim.opt.termguicolors = true
