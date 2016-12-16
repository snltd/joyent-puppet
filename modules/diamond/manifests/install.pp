#
# set up everything diamond needs. It's not a package yet.
#
class diamond::install(
)
{
  user { 'diamond':
    ensure     => present,
    home       => '/opt/local/diamond',
    shell      => '/bin/false',
    comment    => 'diamond pseudo-user',
    uid        => 108,
    gid        => 12,
    managehome => false,
  }

  file { '/config/diamond':
    ensure  => directory,
  }

  file { '/var/log/diamond':
    ensure => directory,
    owner  => 'diamond',
    mode   => '0700',
  }
}
