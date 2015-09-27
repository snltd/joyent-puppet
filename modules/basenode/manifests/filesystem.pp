#
# put things in place that I always have on my nodes
#
class basenode::filesystem {

  file { ['/usr/local',
          '/usr/local/lib',
          '/usr/local/lib/svc',
          '/usr/local/lib/svc/manifest',
          '/usr/local/lib/svc/method',
          '/config'
         ]:
    ensure  => directory,
  }

}
