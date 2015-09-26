# == Class postfix::params
#
# This class is meant to be called from postfix.
# It sets variables according to platform.
#
class postfix::params {
  case $::osfamily {
    'Debian': {
      $package_name               = 'postfix'
      $package_postfix_mysql_name = 'postfix-mysql'
      $service_name               = 'postfix'
      $config_directory           = '/etc/postfix'
      $main_settings_defaults     = {
        alias_database      => 'hash:/etc/aliases',
        alias_maps          => 'hash:/etc/aliases',
        message_size_limit  => 102400000,
        mydestination       => "${::fqdn}, ${::hostname}, localhost.localdomain, localhost",
        myhostname          => $::fqdn,
        mynetworks          => '127.0.0.0/8, [::ffff:127.0.0.0]/104, [::1]/128',
        myorigin            => '/etc/mailname',
        recipient_delimiter => '+',
        smtpd_banner        => '$myhostname ESMTP $mail_name (Ubuntu)',
      }
      $master_settings_defaults = {
        smtp_inet     => {
          srv_name    => 'smtp',
          srv_type    => 'inet',
          srv_private => 'n',
          srv_command => 'smtpd',
        },
        pickup        => {
          srv_type    => 'fifo',
          srv_private => 'n',
          srv_wakeup  => 60,
          srv_maxproc => 1,
          srv_command => 'pickup',
        },
        cleanup       => {
          srv_type    => 'unix',
          srv_private => 'n',
          srv_maxproc => 0,
          srv_command => 'cleanup',
        },
        qmgr          => {
          srv_type    => 'fifo',
          srv_private => 'n',
          srv_chroot  => 'n',
          srv_wakeup  => 300,
          srv_maxproc => 1,
          srv_command => 'qmgr',
        },
        tlsmgr        => {
          srv_type    => 'unix',
          srv_wakeup  => '1000?',
          srv_maxproc => 1,
          srv_command => 'tlsmgr',
        },
        rewrite       => {
          srv_type    => 'unix',
          srv_command => 'trivial-rewrite',
        },
        bounce        => {
          srv_type    => 'unix',
          srv_maxproc => 0,
          srv_command => 'bounce',
        },
        defer         => {
          srv_type    => 'unix',
          srv_maxproc => 0,
          srv_command => 'bounce',
        },
        trace         => {
          srv_type    => 'unix',
          srv_maxproc => 0,
          srv_command => 'bounce',
        },
        verify        => {
          srv_type    => 'unix',
          srv_maxproc => '1',
          srv_command => 'verify',
        },
        flush         => {
          srv_type    => 'unix',
          srv_private => 'n',
          srv_wakeup  => '1000?',
          srv_maxproc => 0,
          srv_command => 'flush',
        },
        proxymap      => {
          srv_type    => 'unix',
          srv_chroot  => 'n',
          srv_command => 'proxymap',
        },
        proxywrite    => {
          srv_type    => 'unix',
          srv_chroot  => 'n',
          srv_maxproc => 1,
          srv_command => 'proxymap',
        },
        smtp_unix     => {
          srv_name    => 'smtp',
          srv_type    => 'unix',
          srv_command => 'smtp',
        },
        relay           => {
          srv_type      => 'unix',
          srv_command   => 'smtp',
          srv_arguments =>  ['-o smtp_fallback_relay=',],
        },
        showq         => {
          srv_type    => 'unix',
          srv_private => 'n',
          srv_command => 'showq',
        },
        error         => {
          srv_type    => 'unix',
          srv_command => 'error',
        },
        retry         => {
          srv_type    => 'unix',
          srv_command => 'error',
        },
        discard       => {
          srv_type    => 'unix',
          srv_command => 'discard',
        },
        local         => {
          srv_type    => 'unix',
          srv_unpriv  => 'n',
          srv_chroot  => 'n',
          srv_command => 'local',
        },
        virtual       => {
          srv_type    => 'unix',
          srv_unpriv  => 'n',
          srv_chroot  => 'n',
          srv_command => 'virtual',
        },
        lmtp          => {
          srv_type    => 'unix',
          srv_command => 'lmtp',
        },
        anvil         => {
          srv_type    => 'unix',
          srv_maxproc => 1,
          srv_command => 'anvil',
        },
        scache        => {
          srv_type    => 'unix',
          srv_maxproc => 1,
          srv_command => 'scache',
        },
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  # package parameters
  $package_ensure = installed

  # service parameters
  $service_enable = true
  $service_ensure = running
  $service_manage = true
  
  $use_mysql      = false
}
