# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)

<!--
## [<exact release including patch>](<github compare url>) - <release date in YYYY-MM-DD>
### Added
  - <summary of new features>

### Changed
  - <for changes in existing functionality>

### Deprecated
  - <for soon-to-be removed features>

### Removed
  - <for now removed features>

### Fixed
  - <for any bug fixes>

### Security
  - <in case of vulnerabilities>
-->

## [Unreleased](https://github.com/cyverse/atmosphere-ansible/compare/v33-0...HEAD) - YYYY-MM-DD
### Changed
  - Renamed Subspace variables to use Ansible keyword instead of Subspace
    ([#154](https://github.com/cyverse/atmosphere-ansible/pull/154))
  - Changes to make compatible with Ansible 2.6 free of deprecation warnings
    ([#155](https://github.com/cyverse/atmosphere-ansible/pull/155))
  - Changed 'template password-auth' task in ldap role for CentOS to say
    `follow=yes` since before Ansible 2.4 yes was default but now default is
    no. It is required because the `password-auth` file is a link
    ([#155](https://github.com/cyverse/atmosphere-ansible/pull/155))
  - Changed task that install iRods on Ubuntu in `atmo-kanki-irodsclient` to
    first download files before installing with apt module because the apt
    module fails to download the files (must be a bug in Ansible 2.6 because
    the download message is 'OK' but the status code is 'None' and Ansible
    looks for status code 200)
    ([#155](https://github.com/cyverse/atmosphere-ansible/pull/155))
  - Changed `atmo-kanki-irodsclient` and `irods-icommands` roles to download packages from the new iRods HTTPS URLs ([#161](https://github.com/cyverse/atmosphere-ansible/pull/161))

### Removed
  - Remove unused `atmo-irods` role and remove unused CentOS 5 tasks from `irods-icommands` role ([#162](https://github.com/cyverse/atmosphere-ansible/pull/162))

### Fixed
  - Fixed task that runs `dhclient` for CentOS so that it does not fail if the
    process is already running
    ([#156](https://github.com/cyverse/atmosphere-ansible/pull/156))
    ([#163](https://github.com/cyverse/atmosphere-ansible/pull/163))

## [v33-0](https://github.com/cyverse/atmosphere-ansible/compare/...v33-0) - 2018-08-08
### Added
  - On CentOS, the dhclient.d script `ntp.sh` is configured to remove previously
    configured NTP servers in ntp.conf when installing DHCP-provided NTP
    servers. ([#146](https://github.com/cyverse/atmosphere-ansible/pull/146))
  - New logging plugin that will create logs for each instance organized in
    username directories. The plugin is a template that has the log path added
    by the `./configure` script.
    ([#154](https://github.com/cyverse/atmosphere-ansible/pull/154))

### Changed
  - Renamed Subspace variables to use Ansible keyword instead of Subspace
    ([#154](https://github.com/cyverse/atmosphere-ansible/pull/154))

### Fixed
  - Fixed task to kill VNC servers using `pkill` instead of `vncserver -kill
    :$DISPLAY`
    ([#150](https://github.com/cyverse/atmosphere-ansible/pull/150))
  - Fixed task to change desktop background on CentOS 7. This change also
    offered other improvements by using the correct commands to change the
    desktop background instead of overwriting existing files
    ([#151](https://github.com/cyverse/atmosphere-ansible/pull/151))
  - Only modify the permissions when user's home directory is created
    ([#152](https://github.com/cyverse/atmosphere-ansible/pull/152))
  - Change the ownership of the ephemeral disk mount to the user during deploy
    ([#153](https://github.com/cyverse/atmosphere-ansible/pull/153))
