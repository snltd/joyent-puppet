#
# just make sure diamond runs
#
class diamond::service()
{
  service { 'diamond':
    ensure => running,
  }
}
