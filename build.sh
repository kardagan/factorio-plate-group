#!/usr/bin/env bash
#
# build.sh — packaging Plate Group.
#
# Une seule cible : Factorio 2.1. Le mod ne touche qu'aux prototypes item-group /
# item-subgroup, stables depuis 2.0, mais les deux mods qu'il regroupe par défaut
# (textplates, DisplayPlatesForked) sont eux-mêmes en factorio_version 2.1.
#
# Usage :
#   ./build.sh package   # génère dist/plate-group_<version>.zip
#   ./build.sh link      # lien symbolique dev: ~/.factorio/mods/plate-group -> ce repo
#   ./build.sh unlink    # retire le lien dev
#   ./build.sh install   # package, puis copie le zip dans ~/.factorio/mods/
#   ./build.sh clean     # supprime dist/
#
# Dev recommandé : `link` une fois, puis on édite le code et on recharge Factorio.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

MOD_NAME="plate-group"
DIST="$ROOT/dist"

# Allowlist : on ne ship JAMAIS dist/, .git, .claude, docs/, le script de build.
CONTENTS=(
  info.json
  settings.lua
  data-final-fixes.lua
  changelog.txt
  thumbnail.png
  LICENSE
  graphics
  locale
)

mod_version() {
  python3 -c "import json;print(json.load(open('info.json'))['version'])"
}

package() {
  local version; version="$(mod_version)"
  local stage="$DIST/${MOD_NAME}_${version}"

  rm -rf "$DIST"
  mkdir -p "$stage"
  for item in "${CONTENTS[@]}"; do
    [ -e "$item" ] && cp -r "$item" "$stage/"
  done

  ( cd "$DIST" && zip -rq "${MOD_NAME}_${version}.zip" "${MOD_NAME}_${version}" )
  rm -rf "$stage"
  echo "  → dist/${MOD_NAME}_${version}.zip"
}

install_local() {
  package
  local version; version="$(mod_version)"
  local mods="$HOME/.factorio/mods"
  [ -d "$mods" ] || { echo "Dossier mods introuvable: $mods" >&2; exit 1; }
  cp "$DIST/${MOD_NAME}_${version}.zip" "$mods/"
  echo "Installé dans $mods"
}

# Dev: symlink du repo dans le dossier mods pour que les éditions soient live.
# On retire d'abord tout zip packagé du mod, sinon une version plus haute masque
# le lien (dossier non versionné).
link_dev() {
  local mods="$HOME/.factorio/mods"
  [ -d "$mods" ] || { echo "Dossier mods introuvable: $mods" >&2; exit 1; }
  rm -f "$mods/${MOD_NAME}_"*.zip
  ln -sfn "$ROOT" "$mods/$MOD_NAME"
  echo "Lien dev : $mods/$MOD_NAME -> $ROOT"
}

unlink_dev() {
  local mods="$HOME/.factorio/mods"
  if [ -L "$mods/$MOD_NAME" ]; then
    rm -f "$mods/$MOD_NAME"; echo "Lien dev retiré : $mods/$MOD_NAME"
  else
    echo "Aucun lien dev à retirer."
  fi
}

case "${1:-package}" in
  package) package ;;
  link)    link_dev ;;
  unlink)  unlink_dev ;;
  install) install_local ;;
  clean)   rm -rf "$DIST"; echo "dist/ supprimé." ;;
  *) echo "Usage: $0 {package|link|unlink|install|clean}" >&2; exit 1 ;;
esac
