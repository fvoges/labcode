class nginx (
  $root = undef,
) {
  case $::osfamily {
    'RedHat': {
      $pkg_name = 'nginx'
      $user     = 'root'
      $group    = 'root'
      #$docroot  = '/var/www'
      $default_docroot  = '/var/www'
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
      #$docroot  = '/var/www'
      $default_docroot  = '/var/www'
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
      #$docroot  = 'C:/ProgramData/nginx/html'
      $default_docroot  = 'C:/ProgramData/nginx/html'
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
  
  $docroot = $root ? {
    undef   => $default_docroot,
    default => $root,
  }

  File {
    owner  => $user,
    group  => $group,
    mode   => '0644',
  }

  package { $pkg_name:
    ensure => present,
  }

  file { "${confdir}/nginx.conf":
    ensure  => file,
    content => epp('nginx/nginx.conf.epp'),
    require => Package[$pkg_name],
    notify  => Service[$svc_name],
  }

  service { $svc_name:
    ensure    => running,
    enable    => true,
  }

  nginx::vhost { 'default':
    docroot    => $docroot,
    servername => $::fqdn,
  }
}

