return {
  'jcarlos7121/avante.nvim',
  event = "VeryLazy",
  version = false,
  opts = {
    provider = 'copilot-gemini-2.5',
    mode = 'agentic',
    cursor_applying_provider = 'groq',
    auto_suggestions_provider = 'copilot-gemini-2.5',
    behaviour = {
      auto_suggestions = false,
      auto_apply_diff_after_generation = false,
      auto_focus_on_diff_view = false,
      enable_cursor_planning_mode = false,
      enable_token_counting = false,
      use_cwd_as_project_root = true
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
    mappings = {
      ask = "<leader>4", -- ask
      edit = "<leader>6", -- edit
    },
    hints = { enabled = false },
    rag_service = {
      enabled = true, -- Enables the RAG service
      host_mount = "/Users/juanhinojo",
      provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
      llm_model = "llama3", -- The LLM model to use for RAG service
      embed_model = "nomic-embed-text", -- The embedding model to use for RAG service
      endpoint = "http://host.docker.internal:11434", -- The API endpoint for RAG service
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
      ["anthropic-claude-3-5"] = {
        __inherited_from = "claude",
        model = "claude-3-5-sonnet-20241022",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 8192,
      },
      ["anthropic-claude-haiku"] = {
        __inherited_from = "claude",
        model = "claude-3-5-haiku-20241022",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 8192,
      },
      ["copilot-claude-3.5"] = {
        __inherited_from = "copilot",
        model = "claude-3.5-sonnet",
      },
      ["copilot-claude-3.7"] = {
        __inherited_from = "copilot",
        model = "claude-3.7-sonnet",
      },
      ["copilot-gemini-2.5"] = {
        __inherited_from = "copilot",
        model = "gemini-2.5-pro",
      },
      groq = {
        __inherited_from = 'openai',
        api_key_name = 'GROQ_API_KEY',
        endpoint = 'https://api.groq.com/openai/v1/',
        model = 'llama-3.3-70b-versatile',
        max_tokens = 32768,
      },
    }
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
