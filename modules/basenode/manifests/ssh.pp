#
# Configure DNS
#
class basenode::ssh(
  $dns_domain = undef,
  $dns_servers = undef,
){

  file { '/etc/ssh/sshd_config':
    source => 'puppet:///modules/basenode/sshd_config',
    notify => Service['ssh'],
  }

  service { 'ssh':
    ensure => running,
  }

  file { '/var/log/sshd.log':
    ensure => present,
    mode   => '0600',
    group  => 'sys',
  }

}
