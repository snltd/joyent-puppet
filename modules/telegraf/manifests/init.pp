# Install Telegraf, and configure it.  The binary and SMF manifest
# are in ../files and the config file in ../templates.
#
class telegraf(
  $wavefront_endpoint = hiera('wavefront_endpoint', 'wavefront'),
  $manta              = hiera('manta_uri'),
  $tmp                = '/var/tmp',
  $file               = 'telegraf',
  $telegraf_svc       = hiera('telegraf_svc', 'running'),
) {
{
  file { ['/config/telegraf', '/var/log/telegraf']:
    ensure => directory,
    owner  => 'telegraf',
  }

  file { '/config/telegraf/telegraf.conf':
    content => template('telegraf/telegraf.conf.erb'),
    notify  => Service['telegraf'],
  }

  exec { 'fetch_telegraf':
    command => "/usr/bin/wget --no-check-certificate -P ${tmp} \
                ${manta}/${file}",
    unless  => "test -f ${tmp}/${file}}",
  } ->

  file { '/opt/local/bin/telegraf':
    source => "${tmp}/${file}",
    mode   => '0755',
  } ->

  user { 'telegraf':
    uid     => 988,
    shell   => '/bin/false',
    comment => 'metric collector',
    home    => '/var/log/telegraf',
    gid     => 'daemon',
  }

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
