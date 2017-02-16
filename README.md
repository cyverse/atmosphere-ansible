Atmosphere's Ansible Instance Deployment Setup
==============================================

This is an extension point for [Atmosphere](https://github.com/cyverse/atmosphere). It defines (with Ansible) how Atmosphere's instances deploy within the targeted cloud provider.

To look at how Atmosphere utilizes this module, look at the [`service.deploy.py`](https://github.com/cyverse/atmosphere/blob/master/service/deploy.py) and our [subspace](https://github.com/cyverse/subspace) module.

Extension Point?
----------------
We use this term to denote that an installation of Atmosphere could customize / modify the actions performed when deploying virtual machine instances to a cloud provider by alter the [playbooks](ansible/playbooks) defined here.

Execution Order
---------------
The number prefixing the name of a playbook (example: [`20_atmo_dhcp.yml`](ansible/playbooks)) is used to determine the order of execution by [subspace](https://github.com/iPlantCollaborativeOpenSource/subspace). So `20_atmo_dhcp.yml` happens after `15_atmo_ntp.yml`. And, `66_atmo_user_ssh_keys.yml` will happen _last_ even though it appears second in a directory listing of [playbooks](ansible/playbooks).  To prevent this, ensure that playbook names do not exceed a prefix of 100.  Here is a list of currently executed playbooks:

```
ansible/playbooks/
├── 00_check_networking.yml
├── 05_ssh_setup.yml
├── 10_atmo_pre_setup.yml
├── 15_atmo_ntp.yml
├── 20_atmo_dhcp.yml
├── 21_atmo_hostname.yml
├── 22_iplant_ldap.yml
├── 25_atmo_common.yml
├── 30_atmo_mount_home.yml
├── 40_atmo_setup_user.yml
├── 45_atmo_fail2ban.yml
├── 49_atmo_irods.yml
├── 50_atmo_realvnc.yml
├── 55_atmo_idrop.yml
├── 56_atmo_cleanup.yml
├── 60_atmo_postbootscripts.yml
├── 65_gateone-gen-sshkey.yml
└── 66_atmo_user_ssh_keys.yml
```

## Configuring atmosphere-ansible

Atmosphere-ansible provides optional functionality that is used in some, but not all deployments.

Enable these optional configurations by setting the corresponding variable to `true` (e.g. in your Ansible group_vars).

| **Variable**             | **Purpose**                                               |
|--------------------------|-----------------------------------------------------------|
| SETUP_DHCP_CLIENT        | DHCP client                                               |
| SETUP_LDAP               | LDAP client for user authentication                       |
| SETUP_LOCAL_USER_ACCOUNT | Local user account (always runs when SETUP_LDAP not true) |
| SETUP_IRODS_ICOMMANDS    | iRODS iCommands and iRODS FUSE client                     |
| SETUP_REALVNC_SERVER     | RealVNC server for Atmosphere Web Desktop feature         |
| SETUP_GLOBUS_CONNECT     | [Globus Connect](https://www.globus.org/globus-connect)   |

## Utility Playbooks

These playbooks are called separately via `subspace` to verify things such as network connectivity and VNC status for Atmosphere deployments.

```
ansible/util_playbooks/
├── atmo_check_vnc.yml
└── check_networking.yml
```

## Troubleshooting Instances
See this troubleshooting page: [Troubleshooting Atmosphere Ansible](docs/troubleshooting_atmo_ansible.md)

## Contributing to atmosphere-ansible
Generally, new roles should be created using [ansible-role-template](https://github.com/cyverse-ansible/ansible-role-template) using Ansible Galaxy. Optionally, test roles using Travis CI as detailed [here](https://github.com/c-mart/atmosphere-guides/blob/91106b7422fb24ccc87280519147d0c7bcbe629a/src/contribution_guide/contribution_guide.md#ansible-galaxy-roles).

# License

See [LICENSE](LICENSE) file.
