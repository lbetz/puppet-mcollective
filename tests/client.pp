include mcollective::client

mcollective::client::user { 'lbetz':
  ensure => present,
  user   => 'root',
  group  => 'root',
  home   => '/root',
}
