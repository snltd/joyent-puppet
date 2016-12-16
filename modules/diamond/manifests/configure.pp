#
# Configure Diamond with SunOS reporters
#
class diamond::configure(
  $manifest = "${diamond_prefix}/lib/svc/manifest/diamond.xml",
) inherits diamond::params
{
  file { '/config/diamond/diamond.conf':
    content => template('diamond/diamond.conf.erb'),
  }

  exec { 'install_manifest':
    command => "svccfg import ${manifest}",
    unless  => 'svcs diamond',
    notify  => Service['diamond'],
  }
}
