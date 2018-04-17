# Install Filebeat, and configure it.  The binary and SMF manifest
# are in ../files and the config file in ../templates.
#
class filebeat(
  $wavefront_endpoint = hiera('wavefront_endpoint', 'wavefront'),
  $filebeat_svc       = hiera('filebeat_svc'),
  $manta              = hiera('manta_uri'),
  $tmp                = '/var/tmp',
  $file               = 'filebeat',
)
{
  exec { 'fetch_filebeat':
    command => "/usr/bin/wget --no-check-certificate -P ${tmp} \
                ${manta}/${file}",
    unless  => "test -f ${tmp}/${file}}",
  } ->

  file { '/opt/local/bin/filebeat':
    source => "${tmp}/${file}",
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
    content => template('filebeat/filebeat.yaml.erb'),
    owner   => 'logs',
    notify  => Service['filebeat'],
  }

  file { '/opt/local/lib/svc/manifest/filebeat.xml':
    source => 'puppet:///modules/filebeat/filebeat.xml',
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
