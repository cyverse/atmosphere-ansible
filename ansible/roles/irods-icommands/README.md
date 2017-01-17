irods-icommands
=========

Installs the [iCommands](https://pods.iplantcollaborative.org/wiki/display/DS/Using+iCommands) 4.1.9<sup>[1](#centosfootnote)</sup> client for [iRODS](http://irods.org/), including irodsFs

[![Build Status](https://travis-ci.org/CyVerse-Ansible/ansible-irods-icommands.svg?branch=master)](https://travis-ci.org/CyVerse-Ansible/ansible-irods-icommands)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-irods--icommands-blue.svg)](https://galaxy.ansible.com/CyVerse-Ansible/irods-icommands/)

Tested working on CentOS 5+ and Ubuntu 12.04+. May also work for Debian and RHEL.

For Ubuntu and CentOS 6+, installs using .deb/.rpm package from [http://irods.org/download/](http://irods.org/download/), mirrored by CyVerse on Amazon S3). Also cleans up links to old iCommands binaries which may have been previously installed outside of a package manager.

<a name="centosfootnote">1</a>: For CentOS 5, no install package is available for iCommands 4.1.9, so we are still using the old iCommands 3.3.1. This role downloads binaries directly and adds them to PATH for all users.

Requirements
------------

None

Role Variables
--------------

None

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: all
      roles:
        - ansible-irods-icommands


License
-------

See license.md

Author Information
------------------

https://cyverse.org
