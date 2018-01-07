## Chef Workstation

A collection of chef cookbooks used to provision my personal workstations.

#### Install chef-client (Ubuntu)
```
sudo apt-get update
sudo apt-get install curl git
curl -L https://www.chef.io/chef/install.sh | sudo bash
sudo gem install berkshelf
```

#### Install chef-client (Arch)
```
sudo pacman -S git ruby base-devel
git clone https://aur.archlinux.org/chef-dk.git && cd chef-dk
makepkg -si
gem install berkshelf
```

#### Prepare workstation (uses `chef-client --local-mode`)
```
./prepare-node role-name
```

#### Decrypt data bag
```
# Store keys in private location (e.g. Lastpass)
knife data bag show --local-mode --secret-file secrets/my_secret_key tokens duck_dns
```

#### Out of band actions
```
# install grub theme

# if using Secure Boot setup
cryptboot update-grub
# else
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
```

#### Known issues

**ifconfig error:**

If the kernel is updated the ufw recipe might fail with:

```
can't initialize iptables table `filter': Table does not exist (do you need to insmod?)
```
To fix you need to reboot and re-run this recipe.

**display manager is totally busted:**

If something goes wrong and the display manager isn't working, follow these steps to get a root terminal:
1. reboot
1. On the GRUB menu, hit 'e'
1. Add ' single' to the line that starts with 'linux'
1. 'Ctrl-x' to save and continue boot
1. You should now receive a root terminal prompt instead of the display manager
