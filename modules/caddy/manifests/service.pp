#
# start the service up
#
class caddy::service()
{
  service { 'caddy':
    ensure => running,
  }
}
