# Install Telegraf, and configure it.  The binary and SMF manifest
# are in ../files and the config file in ../templates.
#
class telegraf::configure(
  $wf_endpoint = $telegraf::wf_endpoint,
  $svc         = 'svc:/influx/telegraf:default',
  $point_tags  = lookup(telegraf::point_tags, Hash, deep),
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
    notify  => Service[$svc],
  }

  package { 'telegraf':
    ensure  => latest,
    notify  => Service[$svc],
  } ->

  exec { 'telegraf_svc':
    command => '/usr/sbin/svccfg import \
                /opt/local/lib/svc/manifest/telegraf.xml',
    unless  => '/bin/svcs telegraf',
  } ->

  service { $svc:
    ensure => running,
  }
}
