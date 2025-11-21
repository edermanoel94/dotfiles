-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("options")

require("lazy").setup({
  {import = "plugins"},
  {import = "plugins.lsp"},
})

local function create_breakpoint()
    local file = vim.fn.expand("%")
    local line = vim.fn.line(".")
    if file == "" then
        vim.api.nvim_err_writeln("cannot find filename")
        return
    end
    if vim.fn.getline(".") == "" then
        vim.api.nvim_err_writeln("cannot get statement from this line")
        return
    end
    local text = ("b %s:%d"):format(file, line)
    vim.fn.setreg("+", text)
    vim.notify(text)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt.expandtab = false
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4

        vim.keymap.set("n", "<leader>b", create_breakpoint, { buffer = true })

        vim.api.nvim_create_user_command("A", function(opts)
            vim.cmd("GoAlt")
        end, {})

        vim.keymap.set('n', '<leader>c', '<cmd>GoCoverage<CR>', { silent = true })
        vim.keymap.set('n', '<leader>fs', '<cmd>GoFillStruct<CR>', { silent = true })
        vim.keymap.set('n', '<leader>ta', '<cmd>GoAddTag<CR>', { silent = true })
    end
})
