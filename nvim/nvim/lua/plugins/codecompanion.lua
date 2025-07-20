return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      local adapter = "openai" -- Default adapter

      -- Detect if the system supports Ollama (e.g., M1/M2 Mac)
      if vim.fn.has("macunix") == 1 and vim.loop.os_uname().machine == "arm64" then
        adapter = "ollama"
      end

      return {
        strategies = {
          chat = {
            adapter = adapter,
            roles = { llm = "Morpheus", user = "JuanCrg90" },
            slash_commands = {
              ["buffer"] = {
                callback = "strategies.chat.slash_commands.buffer",
                description = "Insert open buffers",
                opts = {
                  contains_code = true,
                  provider = "telescope",
                },
              },
              ["file"] = {
                callback = "strategies.chat.slash_commands.file",
                description = "Insert current file",
                opts = {
                  contains_code = true,
                  provider = "telescope",
                },
              },
            },
          },
          inline = {
            adapter = adapter,
          },
          cmd = {
            adapter = adapter,
          },
        },
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = vim.fn.getenv("OPENAI_API_KEY"),
              },
            })
          end,
        },
        display = {
          chat = {
            show_settings = true,
          },
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ",
            provider = "telescope",
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
        },
        log_level = "DEBUG",
      }
    end,
  },
}
