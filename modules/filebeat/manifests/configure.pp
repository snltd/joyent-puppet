# Install Filebeat, and configure it.  The binary and SMF manifest
# are in ../files and the config file in ../templates.
#
class filebeat::configure(
  $wavefront_endpoint = $filebeat::endpoint,
  $svc                = 'svc:/elastic/filebeat:default',
)
{
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
    content => template('filebeat/filebeat.yaml.erb'),
    owner   => 'logs',
    notify  => Service[$svc],
  }

  package { 'filebeat':
    ensure  => latest,
    notify  => Service[$svc],
  } ->

  exec { 'filebeat_svc':
    command => '/usr/sbin/svccfg import \
                /opt/local/lib/svc/manifest/filebeat.xml',
    unless  => '/bin/svcs filebeat',
  } ->

  service { $svc:
    ensure => running,
  }
}
