## Chef Workstation

A collection of chef cookbooks used to provision my personal workstations.

#### Prepare workstation (uses `chef-client --local-mode`)
```
./prepare-node role-name
```

#### Decrypt data bag
```
knife data bag show --local-mode --secret-file secrets/my_secret_key tokens duck_dns
```
