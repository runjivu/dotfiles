return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "williamboman/mason.nvim",
        "mfussenegger/nvim-dap",
        "jay-babu/mason-nvim-dap.nvim",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        -- install codelldb
        require("mason").setup()
        require("mason-nvim-dap").setup({
            ensure_installed = { 'codelldb' }
        })

        local dap = require('dap')
        local dapui = require('dapui')

        -- Set up Rust debugging with codelldb
        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                args = {"--port", "${port}"},
            }
        }

        dap.configurations.rust = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }

        -- Configure DAP UI
        dapui.setup({
        --    layouts = {
        --        {
        --            elements = {
        --                { id = "scopes", size = 0.25 },
        --                { id = "breakpoints", size = 0.25 },
        --                { id = "stacks", size = 0.25 },
        --                { id = "watches", size = 0.25 },
        --            },
        --            position = "left",
        --            size = 40
        --        },
        --        {
        --            elements = {
        --                { id = "repl", size = 0.5 },
        --                { id = "console", size = 0.5 },
        --            },
        --            position = "bottom",
        --            size = 10
        --        },
        --    },
        })

        -- Automatically open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- Enable virtual text
        require("nvim-dap-virtual-text").setup()

        -- Set up keymaps
        vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<leader>ds', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<leader>dfin', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end, { desc = 'Debug: Set Conditional Breakpoint' })
        vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: Open REPL' })
        vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run Last' })
        
        -- UI toggle
        vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
    end
}
