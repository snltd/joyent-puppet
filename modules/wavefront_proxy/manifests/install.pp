#
# set up everything wavefront_proxy needs
#
class wavefront_proxy::install(
  $tmp     = '/var/tmp',
  $wf_pkg  = 'wavefront-proxy-4.26-1.tgz',
  $jre_ver = '162',
  $jre_src = "server-jre-8u${jre_ver}-solaris-x64.tar.xz",
  $manta   = hiera('manta_uri'),
) {
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
                ${manta}/${wf_pkg}",
    unless  => "test -f ${tmp}/${wf_pkg}",
  } ->

  exec { 'install_proxy_pkg':
    command => "yes | /opt/local/sbin/pkg_add ${tmp}/${wf_pkg}",
    unless  => 'pkgin list | grep -q proxy',
  }

  exec { 'fetch_jre':
    command => "/usr/bin/wget --no-check-certificate -P ${tmp} \
                ${manta}/${jre_src}",
    unless  => "test -f ${tmp}/${jre_src}",
  } ->

  exec { 'install_jre':
    command => "/usr/bin/gtar -C /opt/local -Jxf ${tmp}/${jre_src}",
    unless  => 'test -f /opt/local/java/bin/java',
  } ->

  file { '/opt/local/java':
    ensure => link,
    target => "/opt/local/jdk1.8.0_${jre_ver}",
  }
}
