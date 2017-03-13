#
# install and configure a wavefront_proxy
#
class wavefront_proxy(){

  anchor { 'wavefront_proxy::begin':
    notify  => Class['wavefront_proxy::install'],
  }

  class { 'wavefront_proxy::install':
    require => Anchor['wavefront_proxy::begin'],
    notify  => Class['wavefront_proxy::configure'],
  }

  class { 'wavefront_proxy::configure':
    require => Class['wavefront_proxy::install'],
    notify  => Class['wavefront_proxy::service'],
  }

  class { 'wavefront_proxy::service':
    require => Class['wavefront_proxy::configure'],
    notify  => Anchor['wavefront_proxy::end'],
  }

  anchor { 'wavefront_proxy::end': }
}
