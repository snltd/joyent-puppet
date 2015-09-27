#
# Disable unwanted services, start things we need. The lists are in
# hiera.
#
class basenode::services(
  $online = undef,
  $offline = undef,
) {

  if $online {
    service { $online:
      ensure => running,
    }
  }

  if $offline {
    service { $offline:
      ensure => stopped,
    }
  }

}
