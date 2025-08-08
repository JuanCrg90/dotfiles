return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "franco-ruggeri/codecompanion-spinner.nvim",
    },
    opts = function()
      local adapter = "openai" -- Default adapter
      local model = "gpt-4.1"

      -- Detect if the system supports Ollama (e.g., M1/M2 Mac)
      if vim.fn.has("macunix") == 1 and vim.loop.os_uname().machine == "arm64" then
        adapter = "ollama"
        model = "qwen3"
      end

      return {
        strategies = {
          chat = {
            adapter = adapter,
            model = model,
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
              schema = {
                model = {
                  default = model,
                },
              },
              env = {
                api_key = vim.fn.getenv("OPENAI_API_KEY"),
              },
            })
          end,
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = adapter, -- Give this adapter a different name to differentiate it from the default ollama adapter
              opts = {
                vision = true,
                stream = true,
              },
              schema = {
                model = {
                  default = model,
                },
                num_ctx = {
                  default = 20000,
                },
                think = {
                  -- default = false,
                  -- or, if you want to automatically turn on `think` for certain models:
                  default = function(adapter)
                    -- this'll set `think` to true if the model name contain `qwen3` or `deepseek-r1`
                    local model_name = adapter.model.name:lower()
                    return vim.iter({ "qwen3", "deepseek-r1" }):any(function(kw)
                      return string.find(model_name, kw) ~= nil
                    end)
                  end,
                },
                keep_alive = {
                  default = "5m",
                },
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
        extensions = {
          spinner = {},
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              -- MCP Tools
              make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
              show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
              show_result_in_chat = true, -- Show tool results directly in chat buffer
              format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              -- MCP Resources
              make_vars = true, -- Convert MCP resources to #variables for prompts
              -- MCP Prompts
              make_slash_commands = true, -- Add MCP prompts as /slash commands
            },
          },
        },
        log_level = "DEBUG",
      }
    end,
  },
}
