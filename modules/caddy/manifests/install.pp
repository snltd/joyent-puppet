#
# set up everything caddy needs
#
class caddy::install(
)
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

  file { '/opt/local/bin/caddy':
    source => 'puppet:///modules/caddy/caddy',
    mode   => '0755',
  }

  file { '/opt/local/lib/svc/manifest/caddy.xml':
    source => 'puppet:///modules/caddy/caddy.xml',
  } ->

  exec { 'caddy_svc':
    command => '/usr/sbin/svccfg import \
                /opt/local/lib/svc/manifest/caddy.xml',
    unless  => '/bin/svcs caddy',
  }
}
