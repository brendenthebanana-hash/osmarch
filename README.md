# osmarch
An Arch-based Linux distro, **created by brenden**.

## Build
On an Arch Linux machine, VM, or container:

    sudo ./build.sh

The ISO appears in `out/`. Test it with:

    run_archiso -u -i out/osmarch-*.iso

## Customize
- Add packages: edit `overlay/packages.extra`
- Add files/configs to the live system: put them under `overlay/airootfs/`
- Branding: `overlay/airootfs/etc/{os-release,issue,motd}`
