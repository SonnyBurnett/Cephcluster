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
  # enable 'sudo -i' to become root
  sudo::conf { $user:
    ensure  => 'present',
    content => "%${user} ALL=(root) NOPASSWD: ALL",
  }
  sudo::conf { 'vagrant':
    ensure  => 'present',
    content => '%vagrant ALL=(root) NOPASSWD: ALL',
  }
  # enable ssh trusted relation for cephuser between ceph systems
  file { "$home_dir/.ssh":
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0700',
  }
  file {"$home_dir/.ssh/id_rsa":
    ensure => 'present',
    source => 'puppet:///modules/ceph/cephuser_ssh_id_rsa',
    owner  => $user,
    group  => $user,
    mode   => '0600',
  }
  file {"$home_dir/.ssh/id_rsa.pub":
    ensure => 'present',
    source => 'puppet:///modules/ceph/cephuser_ssh_id_rsa.pub',
    owner  => $user,
    group  => $user,
    mode   => '0600',
  }
  file {"$home_dir/.ssh/authorized_keys":
    ensure => 'present',
    source => 'puppet:///modules/ceph/cephuser_ssh_authorized_keys',
    owner  => $user,
    group  => $user,
    mode   => '0600',
  }
  file {"$home_dir/.ssh/config":
    ensure => 'present',
    source => 'puppet:///modules/ceph/cephuser_ssh_config',
    owner  => $user,
    group  => $user,
    mode   => '0600',
  }
}
