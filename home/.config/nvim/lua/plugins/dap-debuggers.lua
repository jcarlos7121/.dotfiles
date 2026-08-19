return {
  'mfussenegger/nvim-dap',
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "suketa/nvim-dap-ruby",
    "mxsdev/nvim-dap-vscode-js",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require('dap')

    require('dap-vscode-js').setup({
      node_path = 'node',
      debugger_path = os.getenv('HOME') .. '/.DAP/vscode-js-debug',
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    })

    local exts = {
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      -- using pwa-chrome
      'vue',
      'svelte',
    }

    for i, ext in ipairs(exts) do
      dap.configurations[ext] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node)',
          cwd = vim.fn.getcwd(),
          args = { '${file}' },
          sourceMaps = true,
          protocol = 'inspector',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node with ts-node)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = { '--loader', 'ts-node/esm' },
          runtimeExecutable = 'node',
          args = { '${file}' },
          sourceMaps = true,
          protocol = 'inspector',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node with deno)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = { 'run', '--inspect-brk', '--allow-all', '${file}' },
          runtimeExecutable = 'deno',
          attachSimplePort = 9229,
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Test Current File (pwa-node with jest)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = {
            '${workspaceFolder}/node_modules/.bin/jest',
            '--runInBand',
            '-c',
            '${workspaceFolder}/jest.config.js',
          },
          runtimeExecutable = 'node',
          args = { '${file}', '--coverage', 'false'},
          rootPath = '${workspaceFolder}',
          sourceMaps = true,
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Test Current File (pwa-node with vitest)',
          cwd = vim.fn.getcwd(),
          program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
          args = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
          autoAttachChildProcesses = true,
          smartStep = true,
          console = 'integratedTerminal',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Test Current File (pwa-node with deno)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
          runtimeExecutable = 'deno',
          attachSimplePort = 9229,
        },
        {
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Attach Program (pwa-chrome = { port: 9222 })',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          port = 9222,
          webRoot = '${workspaceFolder}',
        },
        {
          type = 'node2',
          request = 'attach',
          name = 'Attach Program (Node2)',
          processId = require('dap.utils').pick_process,
        },
        {
          type = 'node2',
          request = 'attach',
          name = 'Attach Program (Node2 with ts-node)',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          skipFiles = { '<node_internals>/**' },
          port = 9229,
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach Program (pwa-node)',
          cwd = vim.fn.getcwd(),
          processId = require('dap.utils').pick_process,
          skipFiles = { '<node_internals>/**' },
        },
      }
    end

    require('dap-ruby').setup()

    for _, cfg in ipairs(dap.configurations.ruby) do
      if cfg.command == 'bundle' and cfg.args and cfg.args[1] == 'exec' then
        local inner = { unpack(cfg.args, 2) }
        cfg.args = vim.list_extend({ 'exec', 'rdbg', '--open', '-c', '--', 'bundle', 'exec' }, inner)
      end
    end

    -- Attach to this worktree's Rails app, host-run or containerized (rails-dev-docker).
    -- Everything resolves at ATTACH time from the worktree root of nvim's cwd, so the
    -- same entry works across worktrees and regardless of where nvim was launched:
    --   RUBY_DEBUG_PORT          33000 + worktree id (mise.local.toml), fallback 38698
    --   RUBY_DEBUG_LOCAL_FS_MAP  "/app/:<worktree root>" (remote:local)
    -- Host vs container is detected from the process listening on the port: a `ruby`
    -- listener means the app runs on the host, where the /app map would bind every
    -- breakpoint to nonexistent paths (verified:true, never hit) — so identity paths
    -- are sent instead. Any other listener is assumed to be the docker port proxy.
    -- The decision is announced via vim.notify so a wrong mapping is never silent.
    local resolve_rails_debug
    do
      local cache
      resolve_rails_debug = function()
        if cache and (vim.uv.now() - cache.at) < 3000 then return cache end

        local git = vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait()
        local root = vim.trim(git.stdout or '')
        if git.code ~= 0 or root == '' then root = vim.fn.getcwd() end

        local env = {}
        local mise = vim.system({ 'mise', 'env', '--json' }, { cwd = root }):wait()
        if mise.code == 0 then
          local ok, decoded = pcall(vim.json.decode, mise.stdout or '')
          if ok and type(decoded) == 'table' then env = decoded end
        end

        local port = tonumber(env.RUBY_DEBUG_PORT or vim.env.RUBY_DEBUG_PORT or '38698')
        local map = env.RUBY_DEBUG_LOCAL_FS_MAP or vim.env.RUBY_DEBUG_LOCAL_FS_MAP

        local lsof = vim.system({ 'lsof', '-nP', '-iTCP:' .. port, '-sTCP:LISTEN' }):wait()
        local host_app = (lsof.stdout or ''):lower():find('ruby', 1, true) ~= nil

        local mode
        if host_app then
          mode, map = ('host app on :%d — identity paths'):format(port), nil
        elseif map then
          mode = ('container app on :%d — map %s'):format(port, map)
        else
          mode = ('nothing on :%d and no RUBY_DEBUG_LOCAL_FS_MAP — attach will likely fail'):format(port)
        end
        vim.notify('rdbg attach: ' .. mode, vim.log.levels.INFO)

        cache = { at = vim.uv.now(), port = port, localfs = host_app, map = map }
        return cache
      end
    end

    table.insert(dap.configurations.ruby, {
      type = 'ruby',
      request = 'attach',
      name = 'attach rails (this worktree: host or container)',
      server = '127.0.0.1',
      port = function() return resolve_rails_debug().port end,
      -- localfs=true beats any map server-side; explicit false lets localfsMap through
      localfs = function() return resolve_rails_debug().localfs end,
      localfsMap = function() return resolve_rails_debug().map end,
    })

    require("dapui").setup()

    local dap, dapui = require("dap"), require("dapui")

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    -- "Disconnect (without terminating)" sends no terminated/exited event —
    -- the debuggee keeps running — so hook the disconnect request itself.
    dap.listeners.before.disconnect.dapui_config = function()
      dapui.close()
    end

  end
}
