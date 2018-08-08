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

## [Unreleased](https://github.com/cyverse/atmosphere/compare/v33-0...HEAD) - YYYY-MM-DD
## [v33-0](https://github.com/cyverse/atmosphere/compare/...v33-0) - 2018-08-08
### Added
  - On CentOS, the dhclient.d script `ntp.sh` is configured to remove previously
    configured NTP servers in ntp.conf when installing DHCP-provided NTP
    servers. ([#146](https://github.com/cyverse/atmosphere-ansible/pull/146))
  - New logging plugin that will create logs for each instance organized in
    username directories. The plugin is a template that has the log path added
    by the `./configure` script.
    ([#154](https://github.com/cyverse/atmosphere-ansible/pull/154))

### Changed
  - Renamed Subspace variables to use Ansible keyword instead of Subspace ([#154](https://github.com/cyverse/atmosphere-ansible/pull/154))

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
