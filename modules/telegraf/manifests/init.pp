#
# install and configure my home-made Telegraf
#
class telegraf(
  $endpoint = 'undefined',
){
  include telegraf::configure
}
