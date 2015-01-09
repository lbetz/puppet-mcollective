include mcollective::client

mcollective::client::plugin { 'test':
  ensure => foo,
}

mcollective::client::user { 'lbetz':
  ensure => present,
  user   => 'root',
  group  => 'root',
  home   => '/root',
}
