------------------------------------------------------------------------------
-- Plate Group : cree un groupe dedie et y deplace sous-groupes / items.
-- Tout se joue en phase data : les item-group sont des prototypes, ils ne
-- peuvent pas etre crees ni modifies au runtime (control.lua).
------------------------------------------------------------------------------

local GROUP = "plate-group"
local MISC_SUBGROUP = "plate-group-misc"

-- Types de prototypes "item-like" susceptibles d'etre ranges dans un groupe.
local ITEM_TYPES = {
  "item", "item-with-entity-data", "item-with-label", "item-with-inventory",
  "item-with-tags", "blueprint", "blueprint-book", "deconstruction-item",
  "upgrade-item", "copy-paste-tool", "selection-tool", "tool", "ammo",
  "armor", "capsule", "gun", "module", "rail-planner", "repair-tool",
  "spidertron-remote", "space-platform-starter-pack",
}

-- "a, b ,c" -> { "a", "b", "c" }
local function parse_list(value)
  local out = {}
  for entry in string.gmatch(value or "", "[^,;]+") do
    entry = entry:match("^%s*(.-)%s*$")
    if entry ~= "" then out[#out + 1] = entry end
  end
  return out
end

local function setting(name)
  local s = settings.startup[name]
  return s and s.value or nil
end

local subgroup_names = parse_list(setting("plate-group-subgroups"))
local item_names     = parse_list(setting("plate-group-items"))

-- Icone du groupe. Le PNG fait 192x128 : l'icone 128 px suivie de son mipmap
-- 64 px, comme les icones de groupe vanilla (base/graphics/item-group/*.png).
-- Factorio deduit le nombre de mipmaps de la largeur du fichier.
local icon, icon_size = "__plate-group__/graphics/plate-group.png", 128

data:extend({
  {
    type = "item-group",
    name = GROUP,
    order = setting("plate-group-order") or "d-b",
    icon = icon,
    icon_size = icon_size,
  },
  {
    type = "item-subgroup",
    name = MISC_SUBGROUP,
    group = GROUP,
    order = "z",
  },
})

------------------------------------------------------------------------------
-- 1. Deplacement de sous-groupes entiers (cas le plus propre et le plus sur :
--    les items gardent leur ordre relatif, les recettes suivent).
------------------------------------------------------------------------------
local moved_subgroups = 0
for _, name in pairs(subgroup_names) do
  local subgroup = data.raw["item-subgroup"][name]
  if subgroup then
    subgroup.group = GROUP
    moved_subgroups = moved_subgroups + 1
  else
    log("[plate-group] sous-groupe introuvable, ignore : " .. name)
  end
end

------------------------------------------------------------------------------
-- 2. Deplacement d'items individuels vers le sous-groupe fourre-tout.
--    Une recette sans subgroup explicite suit automatiquement son produit
--    principal ; on ne corrige que celles qui en declarent un.
------------------------------------------------------------------------------
local moved_items = 0
for _, name in pairs(item_names) do
  local found = false
  for _, item_type in pairs(ITEM_TYPES) do
    local prototypes = data.raw[item_type]
    local prototype = prototypes and prototypes[name]
    if prototype then
      prototype.subgroup = MISC_SUBGROUP
      found = true
    end
  end
  if found then
    local recipe = data.raw["recipe"][name]
    if recipe and recipe.subgroup then
      recipe.subgroup = MISC_SUBGROUP
    end
    moved_items = moved_items + 1
  else
    log("[plate-group] item introuvable, ignore : " .. name)
  end
end

log(("[plate-group] %d sous-groupe(s) et %d item(s) deplaces dans le groupe '%s'")
  :format(moved_subgroups, moved_items, GROUP))
