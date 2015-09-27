# == Class postfix::service
#
# This class is meant to be called from postfix.
# It ensure the service is running.
#
class postfix::service inherits postfix {

  if $service_manage {
    service { $service_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
