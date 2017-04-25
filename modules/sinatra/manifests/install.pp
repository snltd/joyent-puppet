#
# All sites will run as the user defined in `params.pp`, and will be
# behind an nginx proxy.
#
class sinatra::install(
  $user = $sinatra::params::user,
) inherits sinatra::params
{
  user { $user:
    ensure   => present,
    home     => '/var/tmp',
    shell    => '/bin/false',
    comment  => 'Sinatra pseudo-user',
    uid      => '4567'
  }

  package { 'nginx':
    ensure => installed,
  } ->

  file { '/opt/local/etc/nginx/sinatra':
    ensure  => directory,
  }

  file { '/var/nginx/cache':
    ensure => directory,
    owner  => 'www',
  }
}
