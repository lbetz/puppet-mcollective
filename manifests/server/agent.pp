# == Define Resource: mcollective::server::agent
#
# Full description of define mcollective::server::agent here.
#
# === Parameters
#
# [*ensure*]
#   Installs agent (present) or removes (absent). Default is present.
#
# [*agent*]
#   Sets the agent name, default is the title.
#
# [*package*]
#   Use this package name for installation. Default: mcollective-${agent}-agent
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define mcollective::server::agent(
  $ensure  = present,
  $agent   = $title,
  $package = undef,
) {

  validate_re($ensure, '^(present|absent)$',
              "${ensure} is not supported for ensure. Valid values are 'present' and 'absent'.")

  include mcollective::params

  # nessesary to use $agent as part of package name
  if $package {
    $_package = $package }
  else {
    $_package = "mcollective-${agent}-agent" }

  package { $_package:
    ensure => $ensure,
    notify => Class['mcollective::server::service'],
  }

}
