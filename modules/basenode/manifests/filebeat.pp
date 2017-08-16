# Install Filebeat, and configure it.  The binary and SMF manifest
# are in ../files and the config file in ../templates.
#
class basenode::filebeat(
  $filebeat_endpoints = hiera('filebeat_endpoints', []),
  $filebeat_svc       = hiera('filebeat_svc'),
)
{
  file { '/opt/local/bin/filebeat':
    source => 'puppet:///modules/basenode/filebeat',
    mode   => '0755',
  }

  # The logs group can be used to help Filebeat read things without it
  # needing to run as root.
  #
  group { 'logs':
    gid => 989,
  } ->

  user { 'logs':
    uid     => 989,
    shell   => '/bin/false',
    comment => 'log shipper',
    home    => '/var/filebeat',
    gid     => 989,
  }

  file { ['/config/filebeat', '/var/log/filebeat', '/var/filebeat']:
    ensure => directory,
    owner  => 'logs',
  }

  file { '/config/filebeat/filebeat.yaml':
    content => template('basenode/filebeat.yaml.erb'),
    owner   => 'logs',
  }

  file { '/opt/local/lib/svc/manifest/filebeat.xml':
    source => 'puppet:///modules/basenode/filebeat.xml',
  } ->

  exec { 'filebeat_svc':
    command => '/usr/sbin/svccfg import \
                /opt/local/lib/svc/manifest/filebeat.xml',
    unless  => '/bin/svcs filebeat',
  } ->

  service { 'filebeat':
    ensure => $filebeat_svc,
  }
}
