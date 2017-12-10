#
# install and configure a caddy proxy server
#
class caddy(){

  anchor { 'caddy::begin':
    notify  => Class['caddy::install'],
  }

  class { 'caddy::install':
    require => Anchor['caddy::begin'],
    notify  => Class['caddy::configure'],
  }

  class { 'caddy::configure':
    require => Class['caddy::install'],
    notify  => Class['caddy::service'],
  }

  class { 'caddy::service':
    require => Class['caddy::configure'],
    notify  => Anchor['caddy::end'],
  }

  anchor { 'caddy::end': }
}
