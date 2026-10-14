#!/usr/bin/env bash
# Build the osmarch ISO. Run on an Arch Linux machine (or Arch VM/container) as root.
set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "Run as root: sudo ./build.sh"; exit 1; }
command -v mkarchiso >/dev/null || pacman -S --needed --noconfirm archiso

HERE="$(cd "$(dirname "$0")" && pwd)"
PROFILE="$HERE/profile"
WORK="$HERE/work"
OUT="$HERE/out"

rm -rf "$PROFILE" "$WORK"
cp -r /usr/share/archiso/configs/releng "$PROFILE"

# Branding in the ISO metadata
sed -i \
  -e 's/^iso_name=.*/iso_name="osmarch"/' \
  -e 's/^iso_label=.*/iso_label="OSMARCH_$(date +%Y%m)"/' \
  -e 's/^iso_publisher=.*/iso_publisher="osmarch <https:\/\/github.com\/brenden\/osmarch> - created by brenden"/' \
  -e 's/^iso_application=.*/iso_application="osmarch Live\/Rescue DVD"/' \
  "$PROFILE/profiledef.sh"

# Branding in boot menus (BIOS syslinux, UEFI grub, systemd-boot)
grep -rl "Arch Linux" "$PROFILE"/{syslinux,grub,efiboot} 2>/dev/null \
  | xargs -r sed -i 's/Arch Linux/osmarch/g'

# Extra packages and files
cat "$HERE/overlay/packages.extra" >> "$PROFILE/packages.x86_64"
cp -rT "$HERE/overlay/airootfs" "$PROFILE/airootfs"

mkarchiso -v -w "$WORK" -o "$OUT" "$PROFILE"
echo "Done. ISO is in: $OUT"
