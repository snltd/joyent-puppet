class sexymf(
){

  anchor { 'sexymf::begin':
    notify  => Class['sexymf::install'],
  }

  class { 'sexymf::install':
    require => Anchor['sexymf::begin'],
    notify  => Class['sexymf::configure'],
  }

  class { 'sexymf::configure':
    require => Class['sexymf::install'],
    notify  => Class['sexymf::service'],
  }

  class { 'sexymf::service':
    require => Class['sexymf::configure'],
    notify  => Anchor['sexymf::end'],
  }

  anchor { 'sexymf::end': }
}
