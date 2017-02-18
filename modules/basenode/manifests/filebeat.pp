# Install Filebeat from my public Manta directory, and configure it.
# The SMF manifest is in ../files and the config file in ../templates.
#
class basenode::filebeat(
  $filebeat = '/opt/local/filebeat',
  $filebeat_endpoints = hiera('filebeat_endpoints', []),
)
{
  exec { 'download_filebeat':
    command => '/bin/wget --no-check-certificate -P /opt/local/bin \
                https://us-east.manta.joyent.com/snltd/public/filebeat',
    creates => $filebeat,
  } ->

  file { $filebeat:
    mode => '0755',
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
    source => 'puppet:///modules/filebeat/filebeat.xml',
  } ->

  exec { 'filbeat_svc':
    command => '/usr/sbin/svccfg /opt/local/lib/svc/manifest/filebeat.xml',
    unless  => '/bin/svcs filebeat',
  }
}
