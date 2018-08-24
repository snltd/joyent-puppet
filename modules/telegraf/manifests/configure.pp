# Install Telegraf, and configure it.  The binary and SMF manifest
# are in ../files and the config file in ../templates.
#
class telegraf::configure(
  $wavefront_endpoint = $telegraf::endpoint,
)
{
  user { 'telegraf':
    uid     => 988,
    shell   => '/bin/false',
    comment => 'metric collector',
    home    => '/var/log/telegraf',
    gid     => 'daemon',
  } ->

  file { ['/config/telegraf', '/var/log/telegraf']:
    ensure => directory,
    owner  => 'telegraf',
  }

  file { '/config/telegraf/telegraf.conf':
    content => template('telegraf/telegraf.conf.erb'),
    notify  => Service['svc:/influx/telegraf:default'],
  }

  package { 'telegraf':
    require => File_line['manta_repo'],
    ensure  => latest,
  }

  file { '/opt/local/lib/svc/manifest/telegraf.xml':
    source => 'puppet:///modules/telegraf/telegraf.xml',
  } ->

  exec { 'telegraf_svc':
    command => '/usr/sbin/svccfg import \
                /opt/local/lib/svc/manifest/telegraf.xml',
    unless  => '/bin/svcs telegraf',
  } ->

  service { 'svc:/influx/telegraf:default':
    ensure => running,
  }
}
