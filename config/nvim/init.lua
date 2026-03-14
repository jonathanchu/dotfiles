-- init.lua — Neovim config inspired by kickstart.nvim and my Emacs setup
-- Requires Neovim 0.11+

-- Leader key (must be set before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- We're using JetBrains Mono Nerd Font (installed via install.sh on Fedora)
vim.g.have_nerd_font = true

-- ==========================================================================
-- Options
-- ==========================================================================

local o = vim.opt

o.number = true
o.relativenumber = true
o.mouse = 'a'
o.showmode = false              -- statusline shows mode
o.clipboard = 'unnamedplus'     -- sync with OS clipboard
o.breakindent = true
o.undofile = true               -- persistent undo
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.inccommand = 'split'          -- live preview of substitutions
o.cursorline = true
o.scrolloff = 10
o.confirm = true                -- ask to save on :q
o.wrap = false
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.termguicolors = true
o.linespace = 4                 -- matches Emacs line-spacing

-- ==========================================================================
-- Keymaps
-- ==========================================================================

-- Clear search highlight on <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic quickfix
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix list' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Navigate splits
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left split' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right split' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower split' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper split' })

-- ==========================================================================
-- Autocommands
-- ==========================================================================

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ==========================================================================
-- Diagnostics
-- ==========================================================================

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '●',
      [vim.diagnostic.severity.WARN] = '●',
      [vim.diagnostic.severity.INFO] = '●',
      [vim.diagnostic.severity.HINT] = '●',
    },
  },
}

-- ==========================================================================
-- Plugin manager (lazy.nvim)
-- ==========================================================================

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================================
-- Plugins
-- ==========================================================================

require('lazy').setup({

  -- ---------- Catppuccin (matching Emacs theme) ----------
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'frappe',         -- same as Emacs GUI config
      integrations = {
        gitsigns = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
        mason = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            warnings = { 'undercurl' },
          },
        },
      },
    },
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- ---------- Which Key ----------
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = 'Search' },
        { '<leader>c', group = 'Code' },
        { '<leader>g', group = 'Git' },
        { '<leader>t', group = 'Toggle' },
      },
    },
  },

  -- ---------- Telescope ----------
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search files' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by grep' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current word' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Search resume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Search recent files' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Search buffers' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search keymaps' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Switch buffer' })

      -- Search in current buffer
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'Fuzzy search in buffer' })
    end,
  },

  -- ---------- LSP ----------
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local builtin = require 'telescope.builtin'
          map('grd', builtin.lsp_definitions, 'Go to definition')
          map('grr', builtin.lsp_references, 'Go to references')
          map('gri', builtin.lsp_implementations, 'Go to implementation')
          map('grt', builtin.lsp_type_definitions, 'Go to type definition')
          map('gO', builtin.lsp_document_symbols, 'Document symbols')
          map('gW', builtin.lsp_dynamic_workspace_symbols, 'Workspace symbols')
          map('grn', vim.lsp.buf.rename, 'Rename')
          map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, 'Go to declaration')

          -- Toggle inlay hints
          if vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle inlay hints')
          end

          -- Highlight references on CursorHold
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- Servers to install and configure
      -- Add servers here as you need them (e.g., pyright, ts_ls, gopls)
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        pyright = {},
        ts_ls = {},
      }

      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        'stylua',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- ---------- Autoformatting ----------
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable for filetypes you don't want auto-formatted
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
      },
    },
  },

  -- ---------- Completion (blink.cmp) ----------
  {
    'saghen/blink.cmp',
    dependencies = { 'L3MON4D3/LuaSnip' },
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      snippets = { preset = 'luasnip' },
      signature = { enabled = true },
    },
  },

  -- ---------- Fugitive (Git commands) ----------
  { 'tpope/vim-fugitive' },

  -- ---------- Git signs ----------
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▁' },
        topdelete = { text = '▔' },
        changedelete = { text = '▎' },
      },
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        map('n', ']h', gs.next_hunk, { desc = 'Next git hunk' })
        map('n', '[h', gs.prev_hunk, { desc = 'Prev git hunk' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset hunk' })
        map('n', '<leader>gb', gs.blame_line, { desc = 'Blame line' })
      end,
    },
  },

  -- ---------- Treesitter ----------
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter',
    lazy = false,
    config = function()
      -- Install parsers matching the Emacs treesitter config
      local parsers = {
        'bash', 'c', 'css', 'diff', 'fish', 'go', 'html',
        'javascript', 'json', 'lua', 'luadoc', 'markdown',
        'markdown_inline', 'python', 'query', 'toml', 'tsx',
        'typescript', 'vim', 'vimdoc', 'yaml',
      }
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local ok, language = pcall(vim.treesitter.language.get_lang, args.match)
          if not ok or not language then return end
          if not pcall(vim.treesitter.language.add, language) then return end
          local started, _ = pcall(vim.treesitter.start, args.buf, language)
          if not started then return end
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- ---------- Todo comments ----------
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- ---------- Mini.nvim (statusline, surround, pairs) ----------
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects (e.g., va) vib)
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (sa, sd, sr)
      require('mini.surround').setup()

      -- Statusline
      require('mini.statusline').setup {
        use_icons = vim.g.have_nerd_font,
      }
    end,
  },

  -- ---------- Guess indentation ----------
  { 'nmac427/guess-indent.nvim', opts = {} },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
