<!--
  Description prête à coller dans le champ "Description" du mod portal Factorio.
  Différence avec le README : pas de liens relatifs au repo, et les images éventuelles
  doivent pointer sur des URLs ABSOLUES raw.githubusercontent.com (les chemins relatifs
  ne fonctionnent pas sur le portail).
  À la prochaine release, mets simplement ce fichier à jour et recolle-le.
-->

A crafting-menu tab that gathers the **signage plates** — [Text Plates](https://mods.factorio.com/mod/textplates) and [Display Plates](https://mods.factorio.com/mod/DisplayPlatesForked) — instead of leaving them buried at the bottom of the Logistics tab.

Unlike the usual one-mod-per-group patches, **the tab's content is configurable from the mod settings**: any other mod's plates can be pulled in without touching a line of Lua.

## Why a mod at all?

Item groups are *prototypes*: they only exist during the data stage, at load time. The runtime API can read them but never create or modify one, so there is no way to build your own crafting tabs from inside a running game. A mod is mandatory — but a single mod can define any number of groups and be driven entirely by startup settings, which is what this one does.

## What it does

Both target mods already declare their own item subgroup, parked in vanilla's Logistics group. This mod simply reassigns those subgroups to a new group, in `data-final-fixes` — after every other mod has had its say. Items keep their relative order, and recipes follow their main product automatically.

Text Plates and Display Plates are **optional dependencies**: the mod loads fine with only one of them installed, or with neither. A subgroup named in the settings but absent from the game is skipped, with a line in the log.

## Settings (startup)

- **Subgroups to move** — default `textplates, display-plates`. A comma-separated list of `item-subgroup` names moved into the tab. This is the clean path: use it whenever the target mod declares its own subgroup.
- **Individual items to move** — empty by default. A comma-separated list of item names, for mods that declare no dedicated subgroup. They land in a catch-all subgroup at the end of the tab.
- **Group order string** — default `d-b`. Decides where the tab sits among the others; `d-b` places it after Combat and before Fluids.

To find a third-party mod's subgroup name, look the item up in Factoriopedia, or grep the mod's `data.lua` for `item-subgroup`.

Changing a startup setting forces a prototype reload, so leave the save, adjust, and reload. An existing save takes the change without trouble — nothing here depends on the group at runtime.

## Credits

Text Plates by *Earendel* and *gheift*; Display Plates (Forked) by *Kingfisher95* and *Flydiverny*. This mod is an independent work, not affiliated with either. English and French locale. MIT licensed.
