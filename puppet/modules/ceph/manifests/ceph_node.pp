class ceph::ceph_node {
  # Create an OSD directory that will be used for the Storage cluster
  file { '/var/local/osd':
    ensure => 'directory',
    # owner  => 'root',
    # group  => 'wheel',
    mode   => '0777',
  }
}
