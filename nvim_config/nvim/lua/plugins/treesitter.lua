return { 
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local ts_configs = require("nvim-treesitter.configs")
        ts_configs.setup({
            ensure_installed = { "python", "lua", "vim", "javascript", "html", "css" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },  
        })
    end
}
