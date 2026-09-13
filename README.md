# Plate Group

A crafting-menu tab that gathers the **signage plates** — [Text Plates](https://mods.factorio.com/mod/textplates)
by *Earendel & gheift* and [Display Plates](https://mods.factorio.com/mod/DisplayPlatesForked)
by *Kingfisher95 & Flydiverny* — instead of leaving them buried at the bottom of the Logistics tab.

Unlike the usual one-mod-per-group patches, the tab's content is **configurable from the mod
settings**: any other mod's plates can be pulled in without touching a line of Lua.

## Why a mod at all?

Item groups are *prototypes*: they only exist during the `data` stage, at load time. The runtime API
(`control.lua`) can read them but never create or modify one, so there is no way to build your own
tabs from inside a running game. A mod is mandatory — but a single mod can define any number of
groups and be driven entirely by startup settings, which is what this one does.

## What it does

Both target mods already declare a dedicated subgroup, parked in vanilla's `logistics` group:

| Mod | Subgroup | Declared in |
| --- | --- | --- |
| Text Plates | `textplates` | `prototype/item-groups.lua` |
| Display Plates | `display-plates` | `data.lua` |

So the mod does not touch the items one by one — it reassigns the `group` of those subgroups in
`data-final-fixes` (i.e. after every other mod has had its say). Items keep their relative order,
and recipes follow their main product automatically.

Both are **optional dependencies**: the mod loads fine with only one of them installed, or neither.
A subgroup named in the settings but absent from the game is skipped with a line in the log.

## Settings (startup)

| Setting | Default | What it does |
| --- | --- | --- |
| Subgroups to move | `textplates, display-plates` | Comma-separated `item-subgroup` names moved into the tab. This is the clean path — use it whenever the target mod declares its own subgroup. |
| Individual items to move | *(empty)* | Comma-separated item names, for mods that declare no dedicated subgroup. They land in a catch-all subgroup at the end of the tab. |
| Group order string | `d-b` | Sort key deciding where the tab sits. `d-b` places it after Combat and before Fluids. |

To find a third-party mod's subgroup name, grep its `data.lua` in `~/.factorio/mods/` for
`item-subgroup`, or look the item up in Factoriopedia.

Changing a startup setting forces a prototype reload, so leave the save, adjust, and reload. An
existing save takes the change without trouble — nothing here depends on the group at runtime.

## Install / build

- **Play:** enable the mod, and optionally Text Plates and/or Display Plates.
- **Dev:** `./build.sh link` symlinks the repo into `~/.factorio/mods/`.
- **Release:** `./build.sh package` produces `dist/plate-group_<version>.zip` for the mod portal.

## Icon

`graphics/plate-group.png` is a 192×128 file: the 128 px icon followed by its 64 px mipmap, the way
vanilla item-group icons are built (`base/graphics/item-group/*.png`). Factorio infers the mipmap
count from the file width, so the prototype only declares `icon_size = 128`.

`docs/icon-source.png` is the 1254×1254 master the two derivatives are cut from; `thumbnail.png`
(144×144, opaque) is the mod-portal vignette.

## Credits

- **Text Plates** — Earendel, gheift
- **Display Plates (Forked)** — Kingfisher95, Flydiverny

Licensed under the [MIT License](LICENSE). This mod is an independent work and is not affiliated
with the authors of Text Plates or Display Plates.
