#
# install service and config file
#
class caddy::configure(
)
{
  file { '/config/caddy/Caddyfile':
    content => template('caddy/Caddyfile.erb'),
  }
}
