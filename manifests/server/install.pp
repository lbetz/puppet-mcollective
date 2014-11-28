# == private Class: mcollective::server::install
#
# Full description of define mcollective::server::install here.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class mcollective::server::install {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $agents = $mcollective::server::agents

  package { ['mcollective', 'mcollective-actionpolicy-auth', 'mcollective-facter-facts']:
    ensure => installed,
  } ->

  file { '/etc/mcollective/ssl/clients':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  } ->

  file{ '/etc/mcollective/facts.yaml':
    owner     => 'root',
    group     => 'root',
    mode      => '400',
    content   => template('mcollective/facts.yaml.erb'),
  }

  ensure_resource(mcollective::server::agent, $agents, { ensure => present })

  File <<| tag == 'mcollective::client::cert' |>>

}
