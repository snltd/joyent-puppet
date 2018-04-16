# Install Telegraf, and configure it.  The binary and SMF manifest
# are in ../files and the config file in ../templates.
#
class telegraf(
  $telegraf_endpoints = hiera('telegraf_endpoints', []),
  $telegraf_svc       = hiera('telegraf_svc', 'running'),
)
{
  file { '/opt/local/bin/telegraf':
    source => 'puppet:///modules/telegraf/telegraf',
    mode   => '0755',
  }

  user { 'telegraf':
    uid     => 988,
    shell   => '/bin/false',
    comment => 'metric collector',
    home    => '/var/log/telegraf',
    gid     => 'daemon',
  }

  file { ['/config/telegraf', '/var/log/telegraf']:
    ensure => directory,
    owner  => 'telegraf',
  }

  file { '/config/telegraf/telegraf.conf':
    content => template('telegraf/telegraf.conf.erb'),
  }

  file { '/opt/local/lib/svc/method/telegraf':
    source => 'puppet:///modules/telegraf/telegraf.method',
    mode   => '0755'
  } ->

  file { '/opt/local/lib/svc/manifest/telegraf.xml':
    source => 'puppet:///modules/telegraf/telegraf.xml',
  } ->

  exec { 'telegraf_svc':
    command => '/usr/sbin/svccfg import \
                /opt/local/lib/svc/manifest/telegraf.xml',
    unless  => '/bin/svcs telegraf',
  } ->

  service { 'telegraf':
    ensure => $telegraf_svc,
  }
}
