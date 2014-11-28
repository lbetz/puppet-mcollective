# == Define resource: mcollective::client::user
#
# Full description of class mcollective::client::user here.
#
# === Parameters
#
# Document parameters here.
#
# [*certname*]
#   Name of the certificate file, the suffix .pem is automatically added. Default
#   is the 'title' of the define resource.
#
# [*user*]
#   User to use and the owner of all files. Default is the 'title'.
#
# [*group*]
#   Group to use and the group of all files. Default is the 'title'.
#
# [*home*]
#   The home directory of the chosen user. Default ist the '/home/title'.
#
# [*server_cert*]
#   The mcolelctive session certificate. By default a file mcollective-servers.pem
#   is taken from the puppetmaster out of ${caller_module_name}/certs/.
#
# [*key*]
#   Private key of the user, base64 coded. By default a file user.pem is
#   taken from the puppetmaster out of ${caller_module_name}/certs/.
#
# [*cert*]
#   User certificate, base64 coded. By default a file user.pem is
#   taken from the puppetmaster out of ${caller_module_name}/private_keys/.
#
# [*mqueue*]
#   Parameter hash for MQ connection. Defaults are:
#     host     => 'puppet',
#     port     => '61614',
#     user     => 'mcollective',
#     password => 'marionette',
#
#
# === Examples
#
# Set up the nessessary mcollective client environment for user 'batman'. That means
# after installation the configuration '.mcollective' is stored in '/root' and
# the private key and the certificate in '.mcollective.d/credentials/private_keys' and
# 'certs' respectively.
#
# mcollective::client::user { 'batman':
#   user  => 'root',
#   group => 'root',
#   home  => '/root',
# }
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define mcollective::client::user(
  $ensure      = present,
  $certname    = $title,
  $user        = $title,
  $group       = $title,
  $home        = false,
  $server_cert = false,
  $key         = false,
  $cert        = false,
  $mqueue       = {},
) {

  validate_re($ensure, '^(present|absent)$',
              "${ensure} is not supported for ensure. Valid values are 'present' and 'absent'.")
  validate_hash($mqueue)

  include mcollective::params

  $libdir = $params::libdir
  $_mqueue = merge($params::mqueue, $mqueue)

  # set default for home
  if $home {
    validate_absolute_path($home)
    $_home = $home }
  else {
    $_home = "/home/${user}"
  }

  # for testing, because $caller_module_name is not set then calling from top level
  if $caller_module_name {
    $_caller_module_name = $caller_module_name }
  else {
    $_caller_module_name = 'mcollective' }

  # File defaults
  File {
    owner => $user,
    group => $group,
    mode  => '0600',
  }

  # ensure = present
  if $ensure != 'absent' {
    file { "${_home}/.mcollective":
      ensure  => file,
      content => template('mcollective/client.cfg.erb'),
    }

    file { [ "${_home}/.mcollective.d",
             "${_home}/.mcollective.d/credentials",
             "${_home}/.mcollective.d/credentials/certs",
             "${_home}/.mcollective.d/credentials/private_keys",
           ]:
      ensure => directory,
    }

    file { "${_home}/.mcollective.d/credentials/certs/ca.pem":
      ensure => file,
      source => 'file:/var/lib/puppet/ssl/certs/ca.pem',
    }

    if $server_cert {
      file { "${_home}/.mcollective.d/credentials/certs/mcollective-servers.pem":
        ensure  => file,
        content => $server_cert,
      }
    }
    else {
      file { "${_home}/.mcollective.d/credentials/certs/mcollective-servers.pem":
        ensure => file,
        source => "puppet:///modules/${_caller_module_name}/certs/mcollective-servers.pem",
      }
    }

    if $cert {
      file { "${_home}/.mcollective.d/credentials/certs/${certname}.pem":
        ensure  => file,
        content => $cert,
      }
    }
    else {
      file { "${_home}/.mcollective.d/credentials/certs/${certname}.pem":
        ensure => file,
        source => "puppet:///modules/${_caller_module_name}/certs/${certname}.pem",
      }
    }

    if $key {
      file { "${_home}/.mcollective.d/credentials/private_keys/${certname}.pem":
        ensure  => file,
        content => $key,
      }
    }
    else {
      file { "${_home}/.mcollective.d/credentials/private_keys/${certname}.pem":
        ensure => file,
        source => "puppet:///modules/${_caller_module_name}/private_keys/${certname}.pem",
      }
    }
  }
  # ensure = absent
  else {
    file { "${_home}/.mcollective":
      ensure  => absent,
    }
    file { "${_home}/.mcollective.d":
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  }

  if ! defined(File["/etc/mcollective/ssl/clients/${certname}.pem"]) and $ensure != 'absent' {
    if $cert {
      @@file { "/etc/mcollective/ssl/clients/${certname}.pem":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        tag     => 'mcollective::client::cert',
        content => $cert,
        require => Package['mcollective'],
      }
    }
    else {
      @@file { "/etc/mcollective/ssl/clients/${certname}.pem":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        tag     => 'mcollective::client::cert',
        source  => "puppet:///modules/${_caller_module_name}/certs/${certname}.pem",
        require => Package['mcollective'],
      }
    }
  }

}
