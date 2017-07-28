# ansible-kanki-irodsclient

https://travis-ci.org/calvinmclean/ansible-kanki-irodsclient.svg?branch=master

### Description

Ansible to install [kanki-irodsclient](https://github.com/ilarik/kanki-irodsclient). **Current version in this role is 1.0.7**

This role will install kanki-irodsclient and place an icon on the user's desktop. It only works on Ubuntu 14+ and CentOS 6+ distros with GUI.

After the role is completed, the user will have to use the command `iinit` to login to iRods before using the kanki-irodsclient GUI.

### Variables

| Variable                | Required | Default    | Choices                                                          | Comments                                                        |
|-------------------------|----------|------------|------------------------------------------------------------------|-----------------------------------------------------------------|
| ATMOUSERNAME            | yes      | None       | Any username                                                     |                                                                 |
| xsession_path           | yes      | see os-vars| On CentOS, we use `/usr/bin/xinit`, ubuntu we use `/usr/bin/X`   | Used to determine of OS has a GUI                               |
| xterm_path              | yes      | see os-vars| On CentOS, we use `/usr/bin/Xorg`, ubuntu we use `/usr/bin/xinit`| Used to determine of OS has a GUI                               |
| dependencies            | yes      |            | None                                                             | These are the additional packages required by kanki-irodsclient |
| irods_files             | yes      |            | None                                                             | Files to download and install `iRods 4.1.9`                     |
| build_cmd               | yes      |            | None                                                             | Command to build kanki-irodsclient                              |
