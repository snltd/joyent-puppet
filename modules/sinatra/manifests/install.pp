#
# All sites will run as the user defined in `params.pp`
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
}
