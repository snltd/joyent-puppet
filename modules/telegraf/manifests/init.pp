#
# install and configure my home-made Telegraf
#
class telegraf(
  $point_tags  = [],
  $wf_endpoint = undef,
){
  include telegraf::configure
}
