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
  $libdir = $params::libdir

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

  file { "${libdir}/refresh_facts.rb":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('mcollective/refresh_facts.rb.erb'),
  } ->

  exec { "${libdir}/refresh_facts.rb":
    path    => $::path,
    command => "${libdir}/refresh_facts.rb",
    creates => '/etc/mcollective/facts.yaml',
  } ->

  cron { 'mcollective::refresh-facts':
    environment => "PATH=${::path}",
    command     => "${libdir}/refresh_facts.rb",
    user        => 'root',
    minute      => [ '0', '15', '30', '45' ],
  }

  ensure_resource(mcollective::server::agent, $agents, { ensure => present })

  File <<| tag == 'mcollective::client::cert' |>>

}
