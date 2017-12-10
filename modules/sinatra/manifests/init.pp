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
    notify  => Anchor['sinatra::end'],
  }

  anchor { 'sinatra::end': }
}
