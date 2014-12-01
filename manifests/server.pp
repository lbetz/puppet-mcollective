# == Class: mcollective::server
#
# Full description of class mcollective::server here.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   present or running (present), stopped
#
# [*enable*]
#   Enables (true, default) or disables (false) the service to start at boot.
#
# [*agents*]
#   List (array) of agents have to be installed.
#
# [*key*]
#   Private session key to use. Default is a base coded file, source gets from
#   ${caller_module_name}/private_keys/mcollective-servers.pem on the puppetmaster.
#
# [*cert*]
#   Session certificate to use. Default is a base coded file, source gets from
#   ${caller_module_name}/certs/mcollective-servers.pem on the puppetmaster.
#
# [*mqueue*]
#   Parameters hash for MQ connection. Defaults are:
#     host     => 'puppet',
#     port     => '61614',
#     user     => 'mcollective',
#     password => 'marionette',
#
#
# === Examples
#
# Sets up a mcollective server, that connect a message queue on 'master' and
# uses the default user and the given password 'gruelfin'. The agents for package
# and puppet will also be installed.
#
# class { 'mcollective::server':
#   agents => ['package', 'puppet'],
#   mqueue  => {
#     host     => 'master',
#     password => 'gruelfin',
#   }
# }
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class mcollective::server(
  $ensure   = running,
  $enable   = true,
  $agents   = $params::default_agents,
  $key      = false,
  $cert     = false,
  $mqueue    = {},
) inherits mcollective::params {

  validate_re($ensure, '^(present|running|stopped)$',
        "${ensure} is not supported for ensure. Valid values are 'present', 'running' and 'stopped'.")
  validate_bool($enable)
  validate_array($agents)
  validate_hash($mqueue)

  $_mqueue = merge($params::mqueue, $mqueue)

  include install, config, service

  anchor { 'mcollective::server::begin': }
    -> Class['install']
    -> Class['config']
    ~> Class['service']
    -> anchor { 'mcollective::server::end': }

}
