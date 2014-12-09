class mcollective::params {

  $default_agents = [ 'package', 'puppet', 'service' ]
  $default_plugins = $default_agents

  $default_exclude_facts = [
    'system_uptime',
    'uptime.*',
    'rubysitedir',
    '_timestamp',
    'memoryfree.*',
    'swapfree.*',
    'title',
    'name',
    'caller_module_name',
    'module_name',
  ]

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
