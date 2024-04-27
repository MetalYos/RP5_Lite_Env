vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set cursorcolumn")
vim.cmd("set cursorline")
vim.cmd("set hlsearch")
vim.cmd("set incsearch")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set scrolloff=10")
vim.cmd("set smartcase")

-- Set leader key to be space
vim.g.mapleader = " "

-- Press <leader>ns to turn off search highlighting (until the next search)
vim.keymap.set('n', "<leader>ns", function()
    vim.cmd("nohlsearch")
end)

-- Press <leader>tr in normal mode to open terminal at a pane at the bottom
vim.keymap.set('n', "<leader>tr", function()
    vim.cmd("belowright 14split")
    vim.cmd.terminal()
    -- Enter insert mode
    vim.api.nvim_feedkeys("a", "t", false)
end)

-- Press <leader>bc to enter build folder and build using cmake
vim.keymap.set('n', "<leader>bc", function()
    vim.cmd("belowright 10split")
    vim.cmd.terminal()
    -- Send the command to terminal buffer
    vim.api.nvim_chan_send(vim.bo.channel, "cd build && cmake --build .\r")
    -- Enter insert mode
    vim.api.nvim_feedkeys("a", "t", false)
end)
