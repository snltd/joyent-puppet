#
# set up Caddy and everything it needs
#
class caddy::configure(
  $tmp   = '/var/tmp',
  $file  = 'caddy',
  $manta = hiera('manta_uri'),
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

  exec { 'fetch_caddy':
    command => "/usr/bin/wget --no-check-certificate -P ${tmp} \
                ${manta}/${file}",
    unless  => "test -f ${tmp}/${file}",
  } ->

  file { '/opt/local/bin/caddy':
    source => "${tmp}/${file}",
    mode   => '0755',
  }

  file { '/opt/local/lib/svc/manifest/caddy.xml':
    source => 'puppet:///modules/caddy/caddy.xml',
  } ->

  exec { 'caddy_svc':
    command => '/usr/sbin/svccfg import \
                /opt/local/lib/svc/manifest/caddy.xml',
    unless  => '/bin/svcs caddy',
  } ->

  service { 'svc:/mholt/caddy:default':
    ensure => running,
  }
}
