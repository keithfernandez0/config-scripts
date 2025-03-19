-- init.lua

-- Use the packer.nvim plugin manager
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end
vim.cmd('packadd packer.nvim')

-- Auto-install packer.nvim plugins
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  use 'nvim-treesitter/nvim-treesitter'
  use 'preservim/nerdtree'
end)

-- LSP Configuration
local lsp = require('lspconfig')

-- Java LSP configuration
lsp.jdtls.setup{}

-- LaTeX LSP configuration (requires texlab)
lsp.texlab.setup{}

-- Python LSP configuration
lsp.pyright.setup{}

-- Rust LSP configuration
lsp.rust_analyzer.setup{}

-- C/C++ LSP configuration (requires ccls)
lsp.ccls.setup{}

-- Auto-compilation configuration
vim.api.nvim_exec([[
  augroup auto_compile
    autocmd!
    autocmd BufWritePost *.java,*.tex,*.py,*.rs,*.c,*.cpp lua require('utils').auto_compile()
  augroup END
]], false)

-- Syntax highlighting for all languages
require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"java",
		"latex",
		"python",
		"rust",
		"c",
		"cpp",
	},
	highlight = {
		enable = true,
	},
}

-- Set tabs for indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = false

-- Add newline brackets for Java, Rust, C/C++
vim.api.nvim_exec([[
  augroup newline_brackets
    autocmd!
    autocmd FileType java,rust,c,cpp autocmd BufEnter * call append(line("$"), "{")
    autocmd FileType java,rust,c,cpp autocmd BufLeave * call append(line("$"), "}")
  augroup END
]], false)

-- Git integration using fugitive.vim
vim.api.nvim_exec([[
  augroup git_integration
    autocmd!
    autocmd FileType git setlocal signcolumn=no
  augroup END
]], false)

-- Install fugitive.vim using packer
require('packer').startup(function()
  use 'tpope/vim-fugitive'
end)

-- Auto-compile function
_G.utils = {}
function utils.auto_compile()
  local filetype = vim.bo.filetype
  local compile_commands = {
    java = 'javac %:t',
    tex = 'pdflatex %',
    python = 'python3 -m py_compile %',
    rust = 'cargo build',
    c = 'gcc % -o %<',
    cpp = 'g++ % -o %<',
  }
  if compile_commands[filetype] then
    vim.fn.jobstart(compile_commands[filetype], {detach = true})
  end
end

