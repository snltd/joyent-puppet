# set up Caddy and everything it needs
#
class caddy::configure()
{
  user { 'caddy':
    ensure     => present,
    home       => '/var/tmp',
    shell      => '/bin/false',
    comment    => 'caddy pseudo-user',
    uid        => 110,
    gid        => 12,
    managehome => false,
  }

  file { ['/config/caddy', '/config/caddy/vhosts']:
    ensure  => directory,
  }

  file { '/config/caddy/Caddyfile':
    content => template('caddy/Caddyfile.erb'),
  }

  file { '/var/log/caddy':
    ensure => directory,
    owner  => 'caddy',
    group  => 'logs',
    mode   => '0750',
  }

  file { ['/var/caddy', '/var/caddy/vhosts']:
    ensure => directory,
    owner  => 'caddy',
    mode   => '0700',
  }

  package { 'caddy':
    ensure  => latest,
    notify  => Service['caddy'],
  } ->

  exec { 'caddy_svc':
    command => '/usr/sbin/svccfg import \
                /opt/local/lib/svc/manifest/caddy.xml',
    unless  => '/bin/svcs caddy',
  } ->

  service { 'caddy':
    ensure => running,
  }
}
