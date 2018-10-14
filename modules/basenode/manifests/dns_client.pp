#
# Configure DNS
#
class basenode::dns_client(
  $dns_domain = undef,
  $dns_servers = undef,
){
  file { '/etc/resolv.conf':
    content => template('basenode/resolv_conf.erb'),
    notify  => Service['name-service-cache'],
  }

  service { 'name-service-cache':
    ensure => stopped,
  }
}
