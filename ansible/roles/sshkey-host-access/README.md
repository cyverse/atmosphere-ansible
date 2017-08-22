sshkey-host-access
=========

Enable ssh access from an external host to the playbook target as user

This role generates a public key pair for the external host.

Role Variables
--------------

| Variable                | Required | Default                    | Choices  | Comments                                   |
|-------------------------|----------|----------------------------|----------|--------------------------------------------|
| USERNAME                | yes      |                            |          | Username that EXTERNAL_HOST can ssh as     |
| EXTERNAL_HOST           | yes      |                            |          | Ansible host that is granted ssh privilege |
| EXTERNAL_HOST_KEY_OWNER | no       | root                       |          | Owner of generated key pair                |
| EXTERNAL_HOST_KEY_GROUP | no       | root                       |          | Group of generated key pair                |
| EXTERNAL_HOST_KEY_DIR   | no       | /root/.ssh                 |          | Location of generated key pair             |
| EXTERNAL_HOST_KEY_NAME  | no       | id_rsa_{{ EXTERNAL_HOST }} |          | Name of generated key                      |

Example Playbook
----------------

See `ansible/playbooks/instance_deploy/41_shell_access.yml`

Author Information
------------------

https://cyverse.org
