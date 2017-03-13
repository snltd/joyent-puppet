#
# install service and config file
#
class wavefront_proxy::configure(
    $wavefront_token = hiera('wavefront_token'),
)
{
  exec { 'install_wfp_manifest':
    command =>
    "svccfg import /opt/local/wavefront/lib/svc/manifest/wavefront-proxy.xml",
    unless  => 'svcs wavefront/proxy',
  }

  file { '/config/wavefront/wavefront.conf':
    content => template('wavefront_proxy/wavefront.conf.erb'),
  }

  file { '/config/wavefront/log4j2.xml':
    source => 'puppet:///modules/wavefront_proxy/log4j2.xml',
  }

  file { '/config/wavefront/logsIngestion.yaml':
    source => 'puppet:///modules/wavefront_proxy/logsIngestion.yaml',
  }
}
