#
# Install SexyMF from Github. Note that this creates a user with full
# SMF privileges. This may very well not be what you want! Directories
# are consistent with SmartOS.
#
class sexymf::install(
  $install_dir = $sexymf::params::install_dir,
  $node        = $sexymf::params::node,
  $user        = $sexymf::params::user,
  $version     = $sexymf::params::version,
) inherits sexymf::params
{
  package { 'nodejs':
    ensure => installed,
  }

  user { $user:
    ensure   => present,
    profiles => 'Service Operator',
    home     => $install_dir,
    shell    => '/bin/ksh',
    comment  => 'SexyMF pseudo-user',
    uid      => '9206'
  }

  vcsrepo { $install_dir:
    ensure   => present,
    provider => git,
    source  => 'git://github.com/snltd/SexyMF.git',
    revision => $version,
  }

  exec { 'npm':
    command => "cd $install_dir && /opt/local/bin/npm install >/var/log/out",
    require => Vcsrepo[$install_dir],
    unless  => "test -d ${install_dir}/node_modules/restify",
  }

  exec { 'import_manifest':
    command => "/usr/sbin/svccfg import ${install_dir}/support/sexymf.xml",
    require => [Exec['npm'], User[$user], File['manifest']],
    unless  => '/usr/bin/svcs sexymf',
  }

  file { 'manifest':
    path    => "${install_dir}/support/sexymf.xml",
    content => template('sexymf/sexymf.xml.erb'),
  }
}
