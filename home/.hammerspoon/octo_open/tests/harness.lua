-- Minimal zero-dependency test harness (plain Lua, no busted).
local T = { passed = 0, failures = {} }

local function render(value)
  if type(value) ~= "table" then
    return tostring(value)
  end
  local keys = {}
  for k in pairs(value) do
    keys[#keys + 1] = k
  end
  table.sort(keys, function(a, b)
    return tostring(a) < tostring(b)
  end)
  local parts = {}
  for _, k in ipairs(keys) do
    parts[#parts + 1] = string.format("%s = %s", tostring(k), render(value[k]))
  end
  return "{ " .. table.concat(parts, ", ") .. " }"
end

local function same(a, b)
  if a == b then
    return true
  end
  if type(a) ~= "table" or type(b) ~= "table" then
    return false
  end
  for k, v in pairs(a) do
    if not same(v, b[k]) then
      return false
    end
  end
  for k in pairs(b) do
    if a[k] == nil then
      return false
    end
  end
  return true
end

function T.eq(actual, expected)
  if not same(actual, expected) then
    error(string.format("expected %s, got %s", render(expected), render(actual)), 2)
  end
end

function T.test(name, fn)
  local ok, err = pcall(fn)
  if ok then
    T.passed = T.passed + 1
    io.write(".")
  else
    T.failures[#T.failures + 1] = { name = name, err = err }
    io.write("F")
  end
  io.flush()
end

function T.report()
  io.write("\n")
  for _, f in ipairs(T.failures) do
    io.write(string.format("\nFAIL: %s\n  %s\n", f.name, tostring(f.err)))
  end
  io.write(string.format("\n%d passed, %d failed\n", T.passed, #T.failures))
  os.exit(#T.failures == 0 and 0 or 1)
end

return T
