-- Gen 4 Pokédex Limit
--
-- Companion to the National Dex mod.
-- Keeps all Pokémon registered and limits only the visible Pokédex listing.

local MAX_VISIBLE_DEX = 493

local function filterRows(rows)
  if type(rows) ~= "table" then return rows end
  local filtered = {}
  for _, row in ipairs(rows) do
    if type(row) == "table" and type(row.dex) == "number"
      and row.dex <= MAX_VISIBLE_DEX then
      filtered[#filtered + 1] = row
    end
  end
  return filtered
end

local function installGen1(mod)
  if mod.content
    and mod.content.constants
    and type(mod.content.constants.patch) == "function" then
    mod.content.constants:patch("dexSize", MAX_VISIBLE_DEX)
    mod.content.constants:patch("dexDigits", 3)
    return true
  end
  return false
end

local function installGen2(mod)
  local ok, PokedexMenu = pcall(require, "src.ui.gen2.PokedexMenu")
  if not ok or type(PokedexMenu) ~= "table"
    or type(PokedexMenu.rebuild) ~= "function" then
    return false
  end

  if PokedexMenu.gen4DexLimitInstalled then return false end

  local originalRebuild = PokedexMenu.rebuild

  function PokedexMenu:rebuild(...)
    originalRebuild(self, ...)

    if type(self.rows) == "table" then
      self.rows = filterRows(self.rows)

      if #self.rows == 0 then
        self.index = 1
        self.scroll = 0
      else
        self.index = math.max(1, math.min(self.index or 1, #self.rows))
        if type(self.ensureVisible) == "function" then
          self:ensureVisible()
        end
      end
    end
  end

  PokedexMenu.gen4DexLimitInstalled = true
  return true
end

return function(mod)
  local installedGen1 = installGen1(mod)
  local installedGen2 = false
  local okGame, game = pcall(function() return mod.game end)
  local generation = okGame and game and game.generation or nil

  if generation == 2 then
    installedGen2 = installGen2(mod)
  end

  mod.log:info(
    "Gen 4 Pokédex Limit installed (max visible dex #%d; gen1=%s gen2=%s)",
    MAX_VISIBLE_DEX,
    tostring(installedGen1),
    tostring(installedGen2)
  )
end
