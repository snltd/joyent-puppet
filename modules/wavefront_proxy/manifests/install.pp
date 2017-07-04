#
# set up everything wavefront_proxy needs
#
class wavefront_proxy::install(
  $manta = 'https://us-east.manta.joyent.com/snltd/public',
  $tmp   = '/var/tmp',
  $pkg   = 'proxy-4.12-bin.tar.gz',
)
{
  user { 'wavefront':
    ensure     => present,
    home       => '/opt/local/wavefront',
    shell      => '/bin/false',
    comment    => 'wavefront_proxy pseudo-user',
    uid        => 109,
    gid        => 12,
    managehome => false,
  }

  file { '/config/wavefront':
    ensure  => directory,
  }

  file { ['/var/log/wavefront', '/var/wavefront',
          '/var/wavefront/buffer']:
    ensure => directory,
    owner  => 'wavefront',
    mode   => '0700',
  }

  exec { 'fetch_proxy_pkg':
    command => "/usr/bin/wget --no-check-certificate -P ${tmp} \
                ${manta}/${pkg}",
    unless  => "test -f ${tmp}/${pkg}}",
  } ->

  exec { 'install_proxy_pkg':
    command => "yes | /opt/local/sbin/pkg_add ${tmp}/${pkg}",
    unless  => 'pkgin list | grep -q proxy',
  }

  exec { 'fetch_jre':
    command => "/usr/bin/wget --no-check-certificate -P ${tmp} \
                ${manta}/jre-8u121-solaris-x64.tar.xz",
    unless  => "test -f ${tmp}/server-jre-8u121-solaris-x64.tar.xz",
  } ->

  exec { 'install_jre':
    command => "/usr/bin/gtar -C /opt/local \
                -Jxf ${tmp}/jre-8u121-solaris-x64.tar.xz",
    unless  => 'test -f /opt/local/java/bin/java',
  } ->

  file { '/opt/local/java':
    ensure => link,
    target => '/opt/local/jre1.8.0_121',
  }
}
