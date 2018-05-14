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

## [Unreleased](https://github.com/cyverse/atmosphere/compare/...HEAD) - YYYY-MM-DD

### Added

- On CentOS, the dhclient.d script `ntp.sh` is configured to remove previously
  configured NTP servers in ntp.conf when installing DHCP-provided NTP
  servers. ([#146](https://github.com/cyverse/atmosphere-ansible/pull/146))
