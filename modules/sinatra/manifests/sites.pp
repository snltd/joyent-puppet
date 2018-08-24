#
# Fetch some Sinatra websites from Github and configure and start
# them via SMF.
#
class sinatra::sites(
  $user  = $sinatra::params::user,
  $sites = lookup('sinatra'),
) inherits sinatra::params
{
  $sites.each |String $site, $params| {
    $svc = "svc:/sysdef/sinatra/${site}:default"

    package { $site:
      ensure   => latest,
      provider => 'gem',
      source   => $params['repo'],
      notify   => Service[$svc],
    }

    file { "/var/caddy/vhosts/${site}":
      ensure  => directory,
      owner   => 'caddy',
      mode    => '0700',
    }

    file { "/tmp/${site}.xml":
      content => template('sinatra/service.xml.erb'),
    }

    file { "/config/caddy/vhosts/${site}.conf":
      content => template('sinatra/caddy_vhost.erb'),
      require => File['/config/caddy/vhosts'],
      notify  => Service['caddy'],
    }

    exec { "import_${site}_manifest":
      command => "/usr/sbin/svccfg import /tmp/${site}.xml",
      require => File["/tmp/${site}.xml"],
      unless  => "/usr/bin/svcs ${site}",
    } ->

    service { $svc:
      ensure => running,
    }
  }
}
