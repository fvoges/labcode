class nginx (
  $pkg_name = $nginx::params::pkg_name,
  $user     = $nginx::params::user,
  $group    = $nginx::params::group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $confddir = $nginx::params::confddir,
  $logdir   = $nginx::params::logdir,
  $svc_name = $nginx::params::svc_name,
  $svc_user = $nginx::params::svc_user,
) inherits nginx::params {
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

