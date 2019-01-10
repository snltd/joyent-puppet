#
# Configure DNS
#
class basenode::dns_client(){
  service { 'name-service-cache':
    ensure => stopped,
  }
}
