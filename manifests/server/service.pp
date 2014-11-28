# == private Class: mcollective::server::service
#
# Full description of define mcollective::server::service here.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class mcollective::server::service {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $ensure = $server::ensure
  $enable = $server::enable

  service { 'mcollective':
    ensure => $ensure,
    enable => $enable,
  }

}
