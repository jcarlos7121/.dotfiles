return {
  "jcarlos7121/avante.nvim",
  event = "VeryLazy",
  version = false,
  opts = {
    provider = 'claude',
    cursor_applying_provider = 'groq',
    behaviour = {
      auto_suggestions = true,
      auto_focus_on_diff_view = false,
      enable_cursor_planning_mode = false,
      enable_token_counting = false,
      enable_claude_text_editor_tool_mode = true
    },
    disabled_tools = {
        "list_files",    -- Built-in file operations
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",
    },
    system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
    end,
    -- Using function prevents requiring mcphub before it's loaded
    custom_tools = function()
        return {
            require("mcphub.extensions.avante").mcp_tool(),
        }
    end,
    vendors = {
      ["claude-haiku"] = {
        __inherited_from = "claude",
        model = "claude-3-5-haiku-20241022",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 8192,
      },
      deepseek = {
        __inherited_from = 'openai',
        endpoint = 'https://api.deepseek.com',
        model = 'deepseek-coder',
        api_key_name = 'DEEPSEEK_API_KEY',
        max_tokens = 8192,
      },
      groq = { -- define groq provider
        __inherited_from = 'openai',
        api_key_name = 'GROQ_API_KEY',
        endpoint = 'https://api.groq.com/openai/v1/',
        model = 'llama-3.3-70b-versatile',
        max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
      },
    },
    mappings = {
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]q",
        prev = "[q",
      }
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          -- use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
