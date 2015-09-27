# == Class postfix::config
#
# This class is called from postfix for service config.
#
class postfix::config inherits postfix {
  $real_main_settings = merge($main_settings_defaults,$main_settings)
  $real_master_settings = merge($master_settings_defaults,$master_settings)
  file { "${config_directory}/master.cf":
    ensure  => file,
    content => template('postfix/master.cf.erb'),
  }

  file { "${config_directory}/main.cf":
    ensure  => file,
    content => template('postfix/main.cf.erb'),
  }

  if $use_mysql {
    file { '/etc/postfix/mysql-virtual-mailbox-domains.cf':
      ensure  => file,
      content => template('postfix/mysql-virtual-mailbox-domains.cf.erb'),
      notify  => Service['postfix'],
    }
    file { '/etc/postfix/mysql-virtual-mailbox-maps.cf':
      ensure  => file,
      content => template('postfix/mysql-virtual-mailbox-maps.cf.erb'),
      notify  => Service['postfix'],
    }
    file { '/etc/postfix/mysql-virtual-alias-maps.cf':
      ensure  => file,
      content => template('postfix/mysql-virtual-alias-maps.cf.erb'),
      notify  => Service['postfix'],
    }
  }
}
