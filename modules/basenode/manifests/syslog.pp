#
# Configure syslog
#
class basenode::syslog() {

  package { 'rsyslog':
    ensure => installed,
  }

  service { 'system-log':
    ensure => stopped,
  }

  service { 'rsyslog':
    ensure  => running,
    require => Package['rsyslog'],
  }

  file { '/var/adm/loginlog':
    mode  => '0600',
    group => 'sys',
  }

  file { '/etc/syslog.conf':
    source => 'puppet:///modules/basenode/syslog.conf',
    notify => Service['system-log'],
  }

}
