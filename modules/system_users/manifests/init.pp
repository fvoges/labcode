class system_users {
  user { 'fundamentals':
    ensure     => present,
    gid        => 'staff',
    managehome => true,
  }

  group { 'staff':
    ensure => present,
  }

}
