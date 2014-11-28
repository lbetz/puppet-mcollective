# == Define Resource: mcollective::client::plugin
#
# Full description of define mcollective::client::plugin here.
#
# === Parameters
#
# [*ensure*]
#   Installs agent (present) or removes (absent). Default is present.
#
# [*plugin*]
#   Sets the plugin name, default is the title.
#
# [*package*]
#   Use this package name for installation. Default: mcollective-${plugin}-client
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define mcollective::client::plugin(
    $ensure  = present,
    $plugin  = $title,
    $package = undef,
) {

  validate_re($ensure, '^(present|absent)$',
              "${ensure} is not supported for ensure. Valid values are 'present' and 'absent'.")

  include mcollective::params

  # nessessary to use $plugin in package name
  if $package {
    $_package = $package }
  else {
    $_package = "mcollective-${plugin}-client" }

  package { $_package:
    ensure  => $ensure,
  }

}
