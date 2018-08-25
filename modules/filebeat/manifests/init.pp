#
# install and configure filebeat
#
class filebeat(
  $endpoint = 'undefined',
){

  include filebeat::configure
}
