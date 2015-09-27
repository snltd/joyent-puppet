#
# Configure SexyMF
#
class sexymf::configure(
  $install_dir = $sexymf::params::install_dir,
  $cf_dir = "${install_dir}/config",
) inherits sexymf::params
{
  file { "${cf_dir}/config.json":
    source => 'puppet:///modules/sexymf/config.json',
  }

  file { "${cf_dir}/access_list.json":
    source => 'puppet:///modules/sexymf/access_list.json',
  }

  file { "${cf_dir}/users.json":
    source => 'puppet:///modules/sexymf/users.json',
  }

}
