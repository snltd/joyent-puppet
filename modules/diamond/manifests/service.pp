class diamond::service()
{
  service { 'diamond':
    ensure => running,
  }
}
