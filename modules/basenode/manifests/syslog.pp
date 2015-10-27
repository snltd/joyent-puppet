#
# Configure syslog
#
class basenode::syslog() {

  service { 'system-log':
    ensure => 'running',
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
