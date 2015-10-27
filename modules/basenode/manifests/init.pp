#
# Manage the basenode class. All work is done elsewhere
#
class basenode(
) {
  include basenode::dns_client
  include basenode::packages
  include basenode::services
  include basenode::ssh
  include basenode::syslog
  include basenode::users
}
