#
# Configure a Puppet cron job
#
class basenode::puppet(
){

  cron { 'puppet':
    command => '/opt/puppet/puppet-apply.sh',
    user    => 'root',
    minute  => 55,
  }

}
