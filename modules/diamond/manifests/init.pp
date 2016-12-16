#
# install and configure my customized diamond
#
class diamond(
){

  anchor { 'diamond::begin':
    notify  => Class['diamond::install'],
  }

  class { 'diamond::install':
    require => Anchor['diamond::begin'],
    notify  => Class['diamond::configure'],
  }

  class { 'diamond::configure':
    require => Class['diamond::install'],
    notify  => Class['diamond::service'],
  }

  class { 'diamond::service':
    require => Class['diamond::configure'],
    notify  => Anchor['diamond::end'],
  }

  anchor { 'diamond::end': }
}
