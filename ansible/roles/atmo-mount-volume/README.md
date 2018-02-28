Role Name
=========

Mounts a volume on Atmosphere instance.

Role Variables
--------------

| Variable                | Required | Default | Choices                   | Comments                                 |
|-------------------------|----------|---------|---------------------------|------------------------------------------|
| VOLUME_DEVICE           | yes      |         |                           | Location of the device to mount          |
| VOLUME_DEVICE_TYPE      | yes      |         |                           | Filesystem type of device                |
| VOLUME_MOUNT_LOCATION   | yes      |         |                           | Location to mount                        |
| VOLUME_PASSNO           | no       |   2     |                           | see fstab 5                              |
| ATMOUSERNAME            | yes      |         |                           | User that should own the volume          |

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
- name: Mount Volume
  hosts: all
  vars:
    VOLUME_DEVICE:'/dev/sdb'
    VOLUME_MOUNT_LOCATION:'/vol1'
    VOLUME_DEVICE_TYPE: 'ext4'
  roles:
    - atmo-mount-volume
```

Author Information
------------------

https://cyverse.org
