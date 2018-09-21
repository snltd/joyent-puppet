#
# Configure a Puppet cron job, except in dev
#
class basenode::puppet(){
  if $::environment != 'dev' {
    cron { 'puppet':
      command => '/opt/puppet/puppet-apply.sh >/var/log/last_puppet_run.log 2>&1',
      user    => 'root',
      minute  => [0, 20, 40],
    }
  }
}
