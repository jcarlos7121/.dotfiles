local function graphql_fragment_spreads(text)
  local spreads = {}

  for name in text:gmatch("%.%.%.%s*([%w_]+)") do
    if name ~= "on" then
      spreads[name] = true
    end
  end

  return spreads
end

local function normalize_graphql_fragments(query)
  local operation
  local fragment_order = {}
  local fragments = {}
  local pos = 1

  while true do
    local fragment_start, match_end, name = query:find("fragment%s+([%w_]+)%s+on%s+[%w_]+%s*{", pos)

    if not fragment_start then
      break
    end

    if not operation then
      operation = query:sub(1, fragment_start - 1)
    end

    local depth = 1
    local fragment_end = match_end

    for i = match_end + 1, #query do
      local char = query:sub(i, i)
      if char == "{" then
        depth = depth + 1
      elseif char == "}" then
        depth = depth - 1
        if depth == 0 then
          fragment_end = i
          break
        end
      end
    end

    if not fragments[name] then
      local definition = query:sub(fragment_start, fragment_end)
      fragment_order[#fragment_order + 1] = name
      fragments[name] = {
        definition = definition,
        spreads = graphql_fragment_spreads(definition),
      }
    end

    pos = fragment_end + 1
  end

  if not operation then
    return query
  end

  local reachable = {}
  local queue = {}

  for name in pairs(graphql_fragment_spreads(operation)) do
    queue[#queue + 1] = name
  end

  while #queue > 0 do
    local name = table.remove(queue)
    local fragment = fragments[name]

    if fragment and not reachable[name] then
      reachable[name] = true
      for dependency in pairs(fragment.spreads) do
        queue[#queue + 1] = dependency
      end
    end
  end

  local result = { operation }

  for _, name in ipairs(fragment_order) do
    if reachable[name] then
      result[#result + 1] = fragments[name].definition
    end
  end

  return table.concat(result, "\n")
end

local function apply_graphql_fragment_workaround()
  -- Temporary workaround for pwntester/octo.nvim#1491-era queries that
  -- append duplicate or unused GraphQL fragment definitions.
  for _, module_name in ipairs({ "octo.gh.queries", "octo.gh.mutations" }) do
    local ok, module = pcall(require, module_name)
    if ok then
      for key, value in pairs(module) do
        if type(value) == "string" then
          module[key] = normalize_graphql_fragments(value)
        end
      end
    end
  end
end

return {
  'jcarlos7121/octo.nvim',
  branch = 'stacked-prs-all',
  event = "VeryLazy",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',
  },
  config = function()
    require("octo").setup({
      suppress_missing_scope = {
        projects_v2 = true
      }
    })

    apply_graphql_fragment_workaround()
  end
}
