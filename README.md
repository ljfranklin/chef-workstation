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
