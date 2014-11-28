include mcollective::client

mcollective::client::user { 'lbetz':
  ensure => absent,
  user   => 'root',
  group  => 'root',
  home   => '/root',
}
