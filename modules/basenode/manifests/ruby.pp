# Set up any Ruby-specific things
#
class basenode::ruby()
{
  file { '/opt/local/ruby/etc':
    ensure => directory,
  }

  file { '/opt/local/ruby/etc/gemrc':
    source => 'puppet:///modules/basenode/gemrc',
  }
}
