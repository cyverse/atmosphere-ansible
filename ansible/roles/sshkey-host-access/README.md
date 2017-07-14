sshkey-host-access
=========

Create and move keypairs to new instances for access through Web Shells.

Role Variables
--------------

| Variable                | Required | Default | Choices                   | Comments                                 |
|-------------------------|----------|---------|---------------------------|------------------------------------------|
| ATMOUSERNAME            | yes      |         |                           | Username of user getting the keys        |
| GATEONE_LOCAL_PUBKEY_DIR| no       | `/tmp/`    |                           | the directory to transfer the public key locally |
| KEY_LOC_PATH            | yes      |`/var/lib/gateone/users/{{ ATMOUSERNAME }}/.ssh`|| the directory to transfer the public key |
| KEY_LOC_OWNER           | yes      | root    | "root", "tomcat7"         | owner of new keys                        |
| KEY_LOC_GROUP           | yes      | root    | "root", "tomcat7"         | group of new keys                        |
| KEY_LOC_PREFIX          | yes      | ""      | "_guac", ""               | prefix to name key for specific server   |
| play_on                 | yes      | shell   | "shell", "guac_server"    | hostname for delegated tasks             |

Example Playbook
----------------

See `ansible/playbooks/instance_deploy/41_shell_access.yml`

Assumption #1: gateone is installed as root and requires root privileges

Assumption #2: keys generated will automatically be added as a default key

Author Information
------------------

https://cyverse.org
