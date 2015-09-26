# == Class: postfix
#
# This class manages the postfix mailserver.
#
# === Parameters
#
# [*config_directory*]
#   The configuration directory of postfix
#   Default: On Debian '/etc/postfix'g
# [*package_ensure*]
#   See Puppet type 'package' documentation
#   Default: installed
# [*package_name*]
#   Package name to install postfix
#   Default: On Debian 'postfix'
# [*package_postfix_mysql_name*]
#   Package name to install mysql provider for postfix
#   Default: On Debian 'postfix-mysql'
# [*service_name*]
#   Name of the system service to manage.
#   Default: On Debian 'postfix'
# [*service_enable*]
#   See Puppet type 'service' documentation
#   Default: true.
# [*service_ensure*]
#   See Puppet type 'service' documentation
#   Default: running.
# [*service_manage*]
#   If set to false, the Puppet type 'service' will not be created
#   Can be usefull if the service is managed by a cluster manager
#   Default: true.
# [*user_mysql*]
#   If postfix should use the mysql database
#
#
# === Examples
#
#  class { 'postfix':
#    sample_parameter => 'sample value',
#  }
#
# === Authors
#
# Nicolas Bigler
#
# === Copyright
#
# Copyright 2015 Nicolas Bigler
#
class postfix (
  $config_directory            = $::postfix::params::config_directory,
  $package_ensure              = $::postfix::params::package_ensure,
  $package_name                = $::postfix::params::package_name,
  $package_postfix_mysql_name  = $::postfix::params::package_postfix_mysql_name,
  $service_name                = $::postfix::params::service_name,
  $service_enable              = $::postfix::params::service_enable,
  $service_ensure              = $::postfix::params::service_ensure,
  $service_manage              = $::postfix::params::service_manage,
  $use_mysql                   = $::postfix::params::use_mysql,
  $db_host                     = undef,
  $db_name                     = undef,
  $db_user                     = undef,
  $db_password                 = undef,
  $main_settings               = undef,
  $master_settings             = undef,
) inherits ::postfix::params {

  # validate parameters here:
  validate_re($package_ensure, [ '^present', '^installed', '^absent',
    '^purged', '^held', '^latest'])
  validate_string($package_name)
  validate_string($package_postfix_mysql_name)
  validate_string($service_name)
  validate_bool($service_enable)
  validate_re($service_ensure, [ '^running', '^true', '^stopped', '^false'])
  validate_bool($service_manage)
  validate_bool($use_mysql)

  # validate_absolute_path, validate_bool, validate_string, validate_hash
  # validate_array, ... (see stdlib docs)

  class { '::postfix::install': } ->
  class { '::postfix::config': } ~>
  class { '::postfix::service': } 
#  Class['::postfix']

  contain ::postfix::install
  contain ::postfix::config
  contain ::postfix::service

}
