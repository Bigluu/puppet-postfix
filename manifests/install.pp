# == Class postfix::install
#
# This class is called from postfix for install.
#
class postfix::install inherits postfix {

  package { $package_name:
    ensure => $package_ensure,
  }

  if $use_mysql {
    package { $package_postfix_mysql_name:
      ensure => $package_ensure,
    }
  }
}
