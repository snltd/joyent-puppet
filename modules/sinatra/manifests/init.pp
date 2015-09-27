class sinatra(
){

  anchor { 'sinatra::begin':
    notify  => Class['sinatra::install'],
  }

  class { 'sinatra::install':
    require => Anchor['sinatra::begin'],
    notify  => Class['sinatra::sites'],
  }

  class { 'sinatra::sites':
    require => Class['sinatra::install'],
    notify  => Class['sinatra::nginx'],
  }

  class { 'sinatra::nginx':
    require => Class['sinatra::sites'],
    notify  => Anchor['sinatra::end'],
  }

  anchor { 'sinatra::end': }
}
