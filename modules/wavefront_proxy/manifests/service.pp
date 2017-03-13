#
# start the service up
#
class wavefront_proxy::service()
{
  service { 'wavefront/proxy':
    ensure => running,
  }
}
