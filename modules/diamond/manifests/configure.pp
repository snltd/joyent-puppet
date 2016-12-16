#
# Configure Diamond with SunOS reporters
#
class diamond::configure(
  $manifest = "${diamond_prefix}/lib/svc/manifest.xml",
)
{
  file { '/config/diamond/diamond.conf':
    content => template('diamond/diamond.conf.erb',
  }

  exec { 'install_manifest':
    command => "svccfg import ${manifest}",
    unless  => 'svcs diamond',
    notify  => Service['diamond'],
  }
}
