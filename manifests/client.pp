# == Class: mcollective::client
#
# Full description of class mcollective::client here.
#
# === Parameters
#
# Document parameters here.
#
# [*plugins*]
#   List (array) of plugins have to be installed. Defaults 
#   are 'package', 'puppet' andf 'service'.
#
#
# === Examples
#
# Set up the client software and further more the plugins for
# package and puppet management.
#
# class { 'mcollective::client':
#   plugins => ['package', 'puppet'],
# }
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class mcollective::client(
  $plugins = $params::default_plugins,
) inherits mcollective::params {

  validate_array($plugins)

  package { 'mcollective-client':
    ensure => installed,
  }

  ensure_resource(mcollective::client::plugin, $plugins, { ensure => present })

}
