## v2.0.1:

- fix download URL for AUR v4.0.0 (thanks [@fabiendelpierre](https://github.com/fabiendelpierre)!)

## v2.0.0:

- Sets default pacman.build_user to nobody and removes --asroot option, which was removed from pacman in 4.2.0

## v1.1.1:

- Added --noconfirm to to makepkg runs to not prompt on dependencies (thanks [dvolker](https://github.com/dvolker))

## v1.1.0:

### Bug

- Added package namespaces to AUR package installation

## v1.0.4:

### Bug

- [COOK-2971]: pacman cookbook has foodcritic failure

## v1.0.2:

* [COOK-1018] - aur provider fails when a package is of 'any' cpu
  type.
