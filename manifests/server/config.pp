# == private Class: mcollective::server::config
#
# Full description of define mcollective::server::config here.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class mcollective::server::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $libdir   = $params::libdir
  $key      = $server::key
  $cert     = $server::cert
  $mqueue   = $server::_mqueue

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

  file { '/etc/mcollective/server.cfg':
    ensure  => file,
    content => template('mcollective/server.cfg.erb'),
  }

  if $key {
    file { '/etc/mcollective/ssl/servers-private.pem':
      ensure  => file,
      content => $key,
    }
  }
  else {
    file { '/etc/mcollective/ssl/servers-private.pem':
      ensure => file,
      source => "puppet:///modules/${caller_module_name}/private_keys/mcollective-servers.pem",
    }
  }

  if $cert {
    file { '/etc/mcollective/ssl/servers-public.pem':
      ensure  => file,
      mode    => '0644',
      content => $cert,
    }
  }
  else {
    file { '/etc/mcollective/ssl/servers-public.pem':
      ensure => file,
      mode   => '0644',
      source => "puppet:///modules/${caller_module_name}/certs/mcollective-servers.pem",
    }
  }

}
