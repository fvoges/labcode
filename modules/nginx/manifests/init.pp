class nginx {
  case $::osfamily {
    'RedHat': {
      $pkg_name = 'nginx'
      $user     = 'root'
      $group    = 'root'
      $docroot  = '/var/www'
      $confdir  = '/etc/nginx'
      $confddir = "${confdir}/conf.d"
      $logdir   = '/var/log/nginx'
      $svc_name = 'nginx'
      $svc_user = 'nginx'
    }
    'Debian': {
      $pkg_name = 'nginx'
      $user     = 'root'
      $group    = 'root'
      $docroot  = '/var/www'
      $confdir  = '/etc/nginx'
      $confddir = "${confdir}/conf.d"
      $logdir   = '/var/log/nginx'
      $svc_name = 'nginx'
      $svc_user = 'www-data'
    }
    'windows': {
      $pkg_name = 'nginx-service'
      $user     = 'Administrator'
      $group    = 'Administrator'
      $docroot  = 'C:/ProgramData/nginx/html'
      $confdir  = 'C:/ProgramData/nginx/conf'
      $confddir = 'C:/ProgramData/nginx/conf.d'
      $logdir   = 'C:/ProgramData/nginx/logs'
      $svc_name = 'nginx'
      $svc_user = 'nobody'
    }
    default: {
      fail("Operating system not supported: ${::operatingsystem}")
    }
  }
 
  File {
    owner  => $user,
    group  => $group,
    mode   => '0644',
  }

  package { $pkg_name:
    ensure => present,
  }

  file { $docroot:
    ensure => directory,
  }

  file { "${docroot}/index.html":
    ensure => file,
    source => 'puppet:///modules/nginx/index.html',
    before => Service[$svc_name],
  }

  file { "${confdir}/nginx.conf":
    ensure   => file,
    source   => "puppet:///modules/nginx/${::osfamily}.conf",
    require  => Package[$pkg_name],
    notify   => Service[$svc_name],
  }

  file { "${confddir}/default.conf":
    ensure => file,
    source => "puppet:///modules/nginx/default-${::kernel}.conf",
    require => Package[$pkg_name],
    notify  => Service[$svc_name],
  }

  service { $svc_name:
    ensure    => running,
    enable    => true,
  }
}

