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

}
