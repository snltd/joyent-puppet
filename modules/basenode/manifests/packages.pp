#
# add things we need, remove things we don't. Both lists are defined in
# hiera.
#
class basenode::packages(
  $installed = undef,
  $absent    = undef,
) {

  file { '/opt/local/ruby/etc':
    ensure => directory,
  }

  file { '/opt/local/ruby/etc/gemrc':
    source => 'puppet:///modules/basenode/gemrc',
  }

  if $installed {
    package { $installed:
      ensure => installed,
    }
  }

  if $absent {
    package { $absent:
      ensure => absent,
    }
  }
}
