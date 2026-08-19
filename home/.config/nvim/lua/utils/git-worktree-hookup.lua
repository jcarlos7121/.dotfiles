-- After a git-worktree.nvim Switch, run the project's `.git/hooks/post-checkout`
-- hook (resolved via `git rev-parse --git-path`, so linked worktrees work) with
-- git's standard arg signature: <prev_sha> <new_sha> 1. Output streams live into
-- a neogit-style console split (bottom) via a terminal channel. Success auto-
-- closes after 1s; failure stays open. `q`/`<Esc>` closes; `:HookupLog` re-opens
-- the last run. If no executable post-checkout hook exists, the whole thing is
-- a no-op.
--
-- Running the hook is gated behind `config.run_post_checkout` (default false).
-- Enable it via `setup({ run_post_checkout = true })`, or toggle live at any time
-- (the flag is read on each Switch, not cached at setup):
--   require("utils.git-worktree-hookup").config.run_post_checkout = true

local M = {}

M.config = {
  -- When false (default), a worktree Switch will NOT run the post-checkout hook.
  run_post_checkout = false,
}

local last_output = ""
local last_cmd_label = ""

local function open_console(cmd_label)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "HookupConsole"

  local prev_win = vim.api.nvim_get_current_win()
  vim.cmd("botright 15split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].winfixheight = true

  local chan = vim.api.nvim_open_term(buf, {})
  vim.api.nvim_chan_send(chan, "> " .. cmd_label .. "\r\n\r\n")

  local console = {}

  function console.close()
    pcall(vim.fn.chanclose, chan)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  function console.write(data)
    if not data or data == "" then return end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_chan_send(chan, (data:gsub("\n", "\r\n")))
    end
  end

  function console.autoclose(ms)
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_get_current_win() ~= win then
        console.close()
      end
    end, ms)
  end

  vim.keymap.set("n", "q", console.close, { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", console.close, { buffer = buf, silent = true })

  if vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_set_current_win(prev_win)
  end

  return console
end

local function resolve_post_checkout_hook(worktree_path)
  local rel = vim.fn.systemlist({ "git", "-C", worktree_path, "rev-parse", "--git-path", "hooks/post-checkout" })[1]
  if vim.v.shell_error ~= 0 or not rel or rel == "" then return nil end
  local abs = rel:sub(1, 1) == "/" and rel or (worktree_path .. "/" .. rel)
  if vim.fn.executable(abs) ~= 1 then return nil end
  return abs
end

function M.setup(opts)
  opts = opts or {}
  if opts.run_post_checkout ~= nil then
    M.config.run_post_checkout = opts.run_post_checkout
  end

  vim.api.nvim_create_user_command("HookupLog", function()
    local console = open_console(last_cmd_label ~= "" and last_cmd_label or "post-checkout (last run)")
    console.write(last_output == "" and "(no output)" or last_output)
  end, { desc = "Show last post-checkout hook output" })

  local wt = require("git-worktree")
  wt.on_tree_change(function(op, metadata)
    if not M.config.run_post_checkout then return end
    if op ~= wt.Operations.Switch then return end
    local path, prev_path = metadata.path, metadata.prev_path
    if not prev_path then return end
    local prev_sha = vim.fn.systemlist({ "git", "-C", prev_path, "rev-parse", "HEAD" })[1]
    if vim.v.shell_error ~= 0 or not prev_sha then return end
    local new_sha = vim.fn.systemlist({ "git", "-C", path, "rev-parse", "HEAD" })[1]
    if vim.v.shell_error ~= 0 or not new_sha then return end

    local hook = resolve_post_checkout_hook(path)
    if not hook then return end

    local cmd_label = string.format("%s %s %s 1  (cwd: %s)",
      hook, prev_sha:sub(1, 7), new_sha:sub(1, 7), path)
    local console = open_console(cmd_label)
    local buffered = ""

    vim.system(
      { hook, prev_sha, new_sha, "1" },
      {
        cwd = path,
        stdout = vim.schedule_wrap(function(_, data)
          if data then
            buffered = buffered .. data
            console.write(data)
          end
        end),
        stderr = vim.schedule_wrap(function(_, data)
          if data then
            buffered = buffered .. data
            console.write(data)
          end
        end),
      },
      vim.schedule_wrap(function(out)
        last_output = buffered
        last_cmd_label = cmd_label
        if out.code == 0 then
          if buffered:match("^%s*$") then
            console.close()
          else
            console.write("\n[post-checkout ok]\n")
            console.autoclose(1000)
          end
        else
          console.write(string.format("\n[post-checkout failed: exit %s]\n", tostring(out.code)))
        end
      end)
    )
  end)
end

return M
