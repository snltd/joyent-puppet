Exec { path => '/usr/bin:/usr/sbin:/opt/local/bin:/opt/local/sbin' }

File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

node default {
  hiera_include('classes')
}
