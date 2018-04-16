#
# Configure a Puppet cron job, except in dev
#
class basenode::puppet(){
  if $::environment != 'dev' {
    cron { 'puppet':
      command => '/opt/puppet/puppet-apply.sh',
      user    => 'root',
      minute  => [0, 20, 40],
    }
  }
}
