Adapted from https://github.com/jesseadams/pacman and forks by [logankoester](https://github.com/logankoester/) and [illegalprime](https://github.com/illegalprime).

DESCRIPTION
===========

Refreshes the pacman package cache from the FTP servers and provides LWRPs related to pacman

REQUIREMENTS
============

Platform: ArchLinux. Pacman is not relevant on other platforms.

ATTRIBUTES
==========

| Attribute                    | Default                                   | Description                                             |
|------------------------------|-------------------------------------------|---------------------------------------------------------|
| `node['pacman']['build_dir']`    | `/tmp/chef-pacman-builds`               | The default directory where AUR packages will be built. |
| `node['pacman']['build_user']`   | `nobody`                                | The user that will build AUR packages.                  |
| `node['pacman']['install_user']` | `root`                                  | The user that will install AUR and pacman packages.     |

RESOURCES
=========

`pacman_group`
--------------

Use the `pacman_group` resource to install or remove pacman package groups. Note that at this time the LWRP will check if the group is installed but doesn't do a lot of error checking or handling. File a ticket on the COOK project at tickets.opscode.com for improvements and feature requests.

The `options` parameter can be used to pass arbitrary options to the pacman command.

`pacman_aur`
------------

Use the `pacman_aur` resource to install packages from ArchLinux's AUR repository.

### Actions:

* :install - Install deps, builds, then installs the AUR package.

### Parameters:

* version - hardcode a version
* build\_dir - specify an alternate build directory, defaults to `node['pacman']['build_dir']` if set or `/tmp/chef-pacman-builds`.
* build\_user - specify an alternate user to run build commands, defaults to `node['pacman']['build_user']` if set or `nobody`.
* install\_user - specify an alternate user to run install commands, defaults to `node['pacman']['install_user']` if set or `root`.
* options - pass arbitrary options to the pacman command.
* pkgbuild\_src - use a custom PKGBUILD file for the given packages. E.g. `pkgbuild_src({ 'direnv' => 'direnv/PKGBUILD' })` where the custom file is located at `$COOKBOOK/templates/direnv/PKBUILD`
* gpg\_key\_ids - array of gpg key IDs to download prior to running `makepkg`. These keys should match the `validpgpkeys` array given in the PKGBUILD files.
* skippgpcheck - optional, pass the `--skippgpcheck` flag to `makepkg`

http://aur.archlinux.org/

USAGE
=====

Include `recipe[pacman]` early in the run list, preferably first, to ensure that the package caches are updated before trying to install new packages.


LICENSE AND AUTHOR
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Maintainer:: Jesse R. Adams (jesse <at> techno <dash> geeks <dot> org)

Copyright:: Opscode, Inc. (<legal@opscode.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
