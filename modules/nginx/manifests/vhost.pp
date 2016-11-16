define nginx::vhost (
  $servername = $title,
  $port       = '80',
  $docroot    = "${nginx::docroot}/vhosts/${title}",
) {
  File {
    owner => $nginx::user,
    group => $nginx::group,
    mode  => '0644',
  }
  host{ $servername:
    ip => $::ipaddress,
  }

  file { "nginx-vhost-${title}":
    ensure  => file,
    path    => "${nginx::confddir}/${title}.conf",
    content => epp('nginx/vhost.conf.epp',
        {
          port       => $port,
          docroot    => $docroot,
          servername => $servername,
        }),
    notify =>Service[$nginx::svc_name],
  }
  file { $docroot:
    ensure => directory,
    before => File["nginx-vhost-${title}"],
  }

  file { "${docroot}/index.html":
    ensure  => directory,
    content => epp('nginx/index.html.epp',
        {
          servername => $servername,
        }),
    before  => Service[$nginx::svc_name],
  }

}

