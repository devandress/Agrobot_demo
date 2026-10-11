#!/usr/bin/env bash
# Setup FreeCAD (snap) + CROSS workbench (URDF export) on Ubuntu 22.04
set -euo pipefail
MOD="$HOME/snap/freecad/common/Mod"
command -v freecad >/dev/null || sudo snap install freecad
mkdir -p "$MOD"
if [ -d "$MOD/freecad.cross/.git" ]; then
  git -C "$MOD/freecad.cross" pull --ff-only
else
  git clone https://github.com/galou/freecad.cross.git "$MOD/freecad.cross"
fi
# Pin to GNOME dock favorites
cur=$(gsettings get org.gnome.shell favorite-apps)
case "$cur" in *freecad_freecad.desktop*) ;; *)
  gsettings set org.gnome.shell favorite-apps "${cur%]}, 'freecad_freecad.desktop']";; esac
echo "OK. Open FreeCAD -> workbench selector -> Cross."
