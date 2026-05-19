return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "jcarlos7121/neotest-minitest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-minitest"),
      },
      consumers = {
        auto_summary = function(client)
          client.listeners.run = function()
            require("neotest").summary.open()
          end
          client.listeners.results = function(_, results, partial)
            if partial then return end

            -- Close only when the run came back fully green. Any failed, errored, or
            -- skipped status keeps the panel open so we can see what happened. Neotest
            -- aggregates child statuses up to namespaces and file nodes, so iterating
            -- every entry is sufficient — if any test failed, its ancestors here will
            -- also be marked failed.
            local saw_result = false
            local all_passed = true
            for _, result in pairs(results) do
              saw_result = true
              if result.status ~= "passed" then
                all_passed = false
                break
              end
            end

            if saw_result and all_passed then
              require("neotest").summary.close()
            end
          end
          return {}
        end,
      },
    })
  end,
}
