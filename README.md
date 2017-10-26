Atmosphere's Ansible Instance Deployment Setup
==============================================

This is an extension point for [Atmosphere](https://github.com/cyverse/atmosphere). It defines (with Ansible) how Atmosphere's instances deploy within the targeted cloud provider.

To look at how Atmosphere utilizes this module, look at the [`service.deploy.py`](https://github.com/cyverse/atmosphere/blob/master/service/deploy.py) and our [subspace](https://github.com/cyverse/subspace) module.

Extension Point?
----------------
We use this term to denote that an installation of Atmosphere could customize / modify the actions performed when deploying virtual machine instances to a cloud provider by alter the [playbooks](ansible/playbooks) defined here.

Execution Order
---------------
The number prefixing the name of a playbook (example: [`20_atmo_user_install.yml`](ansible/playbooks/instance_deploy)) is used to determine the order of execution by [subspace](https://github.com/iPlantCollaborativeOpenSource/subspace). So `20_atmo_user_install.yml` happens after `18_atmo_local_user_account.yml`. And, `66_atmo_user_ssh_keys.yml` will happen _last_ even though it appears second in a directory listing of [playbooks](ansible/playbooks).  To prevent this, ensure that playbook names do not exceed a prefix of 100.  Here is a list of currently executed playbooks:

```
ansible/playbooks/instance_deploy/
├── 00_setup_ssh.yml
├── 10_setup_pkg_mgr.yml
├── 18_atmo_local_user_account.yml
├── 20_atmo_user_install.yml
├── 30_post_user_install.yml
├── 41_shell_access.yml
└── 42_globus_connect.yml
```

After instance_deploy, these playbooks are run to add user's SSH keys and run their boot scripts.

```
ansible/playbooks/user_deploy/
├── 00_inject_ssh_keys.yml
└── 10_post_boot.yml
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
| SETUP_GUACAMOLE          | [Apache Guacamole](https://guacamole.apache.org/)         |
| SETUP_NOVNC              | NoVNC VNC Client                                          |
| SETUP_GUI_BROWSER        | Web browser on instances with a GUI                       |
| SET_DESKTOP_BACKGROUND   | Set desktop background for instances with a GUI           |
| SETUP_ATMO_BACKUP        | Deploy [cyverse_backup](https://wiki.cyverse.org/wiki/display/atmman/Backing+Up+and+Restoring+Your+Data+to+the+Data+Store) script |

### Guacamole Information

Guacamole is a VNC and SSH gateway. If using this feature, `GUACAMOLE_SERVER_IP` must also be defined.

**Security Warning**: the Guacamole remote desktop requires unencrypted VNC connections from the Guacamole server to your target instances. Ensure that your Guacamole server connects to instances via a trusted network where no unauthorized parties can listen to network traffic. If these connections transit an untrusted network, anyone listening on the wire would get everything from the unencrypted VNC sessions.

## Additional Playbooks

### Utility Playbooks
[These playbooks](ansible/playbooks/utils) are called separately via `subspace` to verify things such as network connectivity and VNC status for Atmosphere deployments.

```
ansible/playbooks/utils/
├── atmo_check_novnc.yml
├── atmo_check_vnc.yml
├── check_networking.yml
├── play_role.yml
└── print_variables.yml
```

### Instance Action Playbooks
[This directory](ansible/playbooks/instance_actions) contains playbooks for performing additionaly actions on an instance post-deploy, such as mounting volumes.
```
ansible/playbooks/instance_actions/
├── check_volume.yml
├── mount_volume.yml
└── unmount_volume.yml
```

### User Customization Playbooks
[This directory](ansible/playbooks/user_customizations) will contain playbooks that can be selected by a user and installed. They may contain additional *metadata* that will help users understand the playbooks intention additionally they may take different *arguments* depending on the purpose of the playbook.

```
ansible/playbooks/user_customizations/
├── README.md
├── add_user.yml
└── remove_user.yml
```

### Imaging Playbooks
[This directory](ansible/playbooks/imaging) contains a playbook `prepare_instance_snapshot.yml` that syncs and freezes an instance to prepare it for imaging process.


## Troubleshooting Instances
See this troubleshooting page: [Troubleshooting Atmosphere Ansible](docs/troubleshooting_atmo_ansible.md)

## Contributing to atmosphere-ansible
Generally, new roles should be created using [ansible-role-template](https://github.com/cyverse-ansible/ansible-role-template) using Ansible Galaxy. Optionally, test roles using Travis CI as detailed [here](https://github.com/c-mart/atmosphere-guides/blob/91106b7422fb24ccc87280519147d0c7bcbe629a/src/contribution_guide/contribution_guide.md#ansible-galaxy-roles).

# License

See [LICENSE](LICENSE) file.
