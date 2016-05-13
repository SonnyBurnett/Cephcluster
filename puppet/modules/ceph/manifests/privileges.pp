class ceph::privileges {
  $user     = 'cephuser'
  $home_dir = "/home/${user}"
  user { $user:
    ensure   => 'present',
    home     => $home_dir,
    password => pw_hash('87654321', 'SHA-512', 'mysalt'),
    shell    => '/bin/bash',
  }
  file { $home_dir:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0700',
  }
  sudo::conf { $user:
    ensure  => 'present',
    content => "%${user} ALL=(root) NOPASSWD: ALL",
  }
  sudo::conf { 'vagrant':
    ensure  => 'present',
    content => '%vagrant ALL=(root) NOPASSWD: ALL',
  }
}
