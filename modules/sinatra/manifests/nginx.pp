#
# Nginx was installed by `install.pp`, and the vhost configs were
# dropped in by `site.pp`. Bit messy maybe.
#
class sinatra::nginx()
{
  file { '/opt/local/etc/nginx/nginx.conf':
    source => 'puppet:///modules/sinatra/nginx.conf',
    notify => Service['nginx'],
  }

  service { 'nginx':
    ensure  => running,
    require => File['/opt/local/etc/nginx/nginx.conf'],
  }

}
