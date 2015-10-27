#
# Just me
#
class basenode::users() {

  group { 'sysadmin':
    gid => 14,
  }

  user { 'rob':
    comment    => 'Robert Fisher',
    gid        => 14,
    uid        => 264,
    shell      => '/bin/ksh',
    home       => '/home/rob',
    managehome => true,
    password   => '$6$rpB6y3bt$CCEk9uxyTHGNdZDAGcdswwgltsw6kQdl6CRbhHqnAZOXWjK54gpCtBI7kAI90zuWg82',
    profiles   => 'Primary Administrator',
  }

  file { '/home/rob/.ssh':
    ensure  => directory,
    owner   => 'rob',
    group   => 'sysadmin',
    mode    => '0700',
    require => User['rob'],
  }

  # Remember default is root:root, 644

  file { '/home/rob/.profile':
    source => 'puppet:///modules/basenode/users/rob/profile',
    owner  => 'rob',
    require => User['rob'],
  }

  file { '/home/rob/.vimrc':
    source => 'puppet:///modules/basenode/users/rob/vimrc',
    owner  => 'rob',
    require => User['rob'],
  }

  file { '/home/rob/.inputrc':
    source => 'puppet:///modules/basenode/users/rob/inputrc',
    owner  => 'rob',
    require => User['rob'],
  }

  file { '/home/rob/.ssh/authorized_keys':
    source  => 'puppet:///modules/basenode/users/rob/authorized_keys',
    owner   => 'rob',
    mode    => '0600',
    require => File['/home/rob/.ssh'],
  }

  user { ['cyrus', 'postfix']:
    ensure => absent,
  }

}
