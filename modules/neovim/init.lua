vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.g.mapleader = " "
vim.opt.signcolumn = "yes"

local map = vim.keymap.set

-- general
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')
map('n', '<leader>cr', ':update<CR>:source<CR>')
map('n', '<leader>co', ':edit ~/.config/nvim/init.lua<CR>')
map({ 'v', 'x' }, '<leader>y', '"+y<CR>')
map({ 'v', 'x' }, '<leader>d', '"+d<CR>')
map({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
map({ 'n', 'v', 'x' }, '<leader>S', ':sf #<CR>')

-- mini.pick
map('n', '<leader>pf', ':Pick files<CR>')
map('n', '<leader>pb', ':Pick buffers<CR>')
map('n', '<leader>ph', ':Pick help<CR>')

-- oil
map('n', '<leader>o', ':Oil<CR>')

-- lsp
map('n', '<leader>li', ':checkhealth vim.lsp<CR>')
map('n', '<leader>la', vim.lsp.buf.code_action)
map('n', '<leader>f', vim.lsp.buf.format)
map('n', 'gd', vim.lsp.buf.definition)
map('n', '<leader>e', ':make<CR>')

-- file specific keymaps
vim.api.nvim_create_autocmd('FileType', {
	pattern = {"typ", "typst"},
	callback = function ()
		vim.schedule(function ()
			vim.keymap.set("n", "<leader>lp", ":TypstPreview<CR>", {buffer = true})
			vim.bo.spelllang = "es"
			vim.cmd("setl spell")
		end)
	end
})


vim.pack.add({
	"https://github.com/vague2k/vague.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/echasnovski/mini.pick",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/chomosuke/typst-preview.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range('v1.7.0') },
})

require "oil".setup()
require "mini.pick".setup()
require "mason".setup()
require "typst-preview".setup()

require 'blink.cmp'.setup({
	signature = { enabled = true },
	fuzzy = { implementation = "rust" },
	keymap = {
		preset = 'none',
		['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		['<C-e>'] = { 'hide', 'fallback' },
		['<C-y>'] = { 'select_and_accept', 'fallback' },

		['<Up>'] = { 'select_prev', 'fallback' },
		['<Down>'] = { 'select_next', 'fallback' },
		['<C-u>'] = { 'select_prev', 'fallback' },
		['<C-d>'] = { 'select_next', 'fallback' },

		['<C-n>'] = { 'scroll_documentation_up', 'fallback' },
		['<C-p>'] = { 'scroll_documentation_down', 'fallback' },

		['<Tab>'] = { 'snippet_forward', 'fallback' },
		['<S-Tab>'] = { 'snippet_backward', 'fallback' },

		['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
	}
})

vim.lsp.enable({ "lua_ls", "rust_analyzer", "jdtls", "tinymist", "basedpyright", "nixd" })
vim.diagnostic.config({ virtual_text = true })

-- colorscheme
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
