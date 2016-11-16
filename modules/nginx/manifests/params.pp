class nginx::params {

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
  
}
