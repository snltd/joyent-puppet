#
# Add things we need, remove things we don't. Both lists are defined
# in hiera.
#
class basenode::packages(
  $installed = [],
  $absent    = [],
)
{
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
