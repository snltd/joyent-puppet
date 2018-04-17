#
# install service and config file
#
class wavefront_proxy::configure(
  $wavefront_token  = $wf_token,
  $wavefront_server = hiera('wavefront_server', 'metrics.wavefront.com'),
  $dc               = hiera('dc', 'undefined'),
  $platform         = hiera('platform', 'undefined'),
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
    content => template('wavefront_proxy/logsIngestion.yaml.erb'),
  }

  file { '/config/wavefront/preprocessor_rules.yaml':
    content => template('wavefront_proxy/preprocessor_rules.yaml.erb'),
  }
}
