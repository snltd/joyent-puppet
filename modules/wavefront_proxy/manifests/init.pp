#
# install and configure a wavefront_proxy
#
class wavefront_proxy(
  $token        = $wf_token,
  $svc          = 'svc:/wavefront/proxy:default',
  $api_endpoint = undef,
  $manifest     = '/opt/local/wavefront-proxy/lib/svc/manifest/wavefront-proxy.xml',
  # Don't use "$tags" as the variable -- it uses the normal Puppet
  # lookup and doesn't recurse down the hierarchy
  $wf_tags      = lookup(wavefront_proxy::tags, Hash, deep),
) {
  user { 'wavefront':
    ensure     => present,
    home       => '/opt/local/wavefront-proxy',
    shell      => '/bin/false',
    comment    => 'wavefront proxy pseudo-user',
    uid        => 109,
    gid        => 12,
    managehome => false,
  }

  file { '/config/wavefront':
    ensure => directory,
  }

  file { ['/var/log/wavefront', '/var/wavefront', '/var/wavefront/buffer']:
    ensure => directory,
    owner  => 'wavefront',
    mode   => '0700',
  }

  package { ['wavefront-proxy', 'server-jre']:
    ensure => present,
  }

  exec { 'install_wfp_manifest':
    command => "/usr/sbin/svccfg import $manifest",
    unless  => "/bin/svcs $svc",
  }

  file { '/config/wavefront/wavefront.conf':
    content => template('wavefront_proxy/wavefront.conf.erb'),
    notify  => Service[$svc],
  }

  file { '/config/wavefront/log4j2.xml':
    source => 'puppet:///modules/wavefront_proxy/log4j2.xml',
    notify => Service[$svc],
  }

  file { '/config/wavefront/logsIngestion.yaml':
    content => template('wavefront_proxy/logsIngestion.yaml.erb'),
    notify  => Service[$svc],
  }

  file { '/config/wavefront/preprocessor_rules.yaml':
    content => template('wavefront_proxy/preprocessor_rules.yaml.erb'),
    notify  => Service[$svc],
  }

  service { $svc:
    ensure => running,
  }
}
