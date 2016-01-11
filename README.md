Atmosphere's Ansible Instance Deployment Setup
==============================================

This is an extension point for [Atmosphere](https://github.com/iPlantCollaborativeOpenSource/atmosphere). It defines (with Ansible) how Atmosphere's instances deploy within the targeted cloud provider. 

To look at how Atmosphere utilizes this modules, look at the [`service.deploy.py`](https://github.com/iPlantCollaborativeOpenSource/atmosphere/blob/master/service/deploy.py) and our [subspace](https://github.com/iPlantCollaborativeOpenSource/subspace) module.

Extension Point?
----------------
We use this term to denote that an installation of Atmosphere could customize / modify the actions performed when deploying virtual machine instances to a cloud provider by alter the [playbooks](ansible/playbooks) defined here. 

Execution Order
---------------
The number prefixing the name of a playbook (example: [`20_atmo_dhcp.yml`](ansible/playbooks)) is used to determine the order of execution by [subspace](https://github.com/iPlantCollaborativeOpenSource/subspace). So `20_atmo_dhcp.yml` happens after `15_atmo_ntp.yml`. And, `100_atmo_user_ssh_keys.yml` will happen _last_ even though it appears second in a directory listing of [playbooks](ansible/playbooks):
```
.
├── 05_ssh_setup.yml
├── 100_atmo_user_ssh_keys.yml
├── 10_atmo_pre_setup.yml
├── 15_atmo_ntp.yml
├── 20_atmo_dhcp.yml
├── 25_atmo_common.yml
├── 30_atmo_mount_home.yml
├── 35_iplant_ldap.yml
├── 40_atmo_setup_user.yml
├── 45_atmo_fail2ban.yml
├── 50_atmo_idrop.yml
├── 55_atmo_realvnc.yml
├── 60_atmo_postbootscripts.yml
└── 65_atmo_shellinabox.yml
```


# License

See [LICENSE](LICENSE) file.
