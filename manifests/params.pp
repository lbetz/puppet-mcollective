# == private Class: mcollective::params
#
# Full description of define mcollective::params here.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class mcollective::params {

  $default_agents = [ 'package', 'puppet', 'service' ]
  $default_plugins = $default_agents

  # defaults to connect activemq
  $mqueue = {
    host      => 'puppet',
    port      => '61614',
    user      => 'mcollective',
    password  => 'marionette',
  }

  case $::osfamily {
    'debian': {
      $libdir = '/usr/share/mcollective/plugins'
    }
    'redhat': {
      $libdir = '/usr/libexec/mcollective'
    }
    default: {
      fail("${::operatingsystem} isn't supported, yet")
    }
  }

}
