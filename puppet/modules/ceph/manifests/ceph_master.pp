class ceph::ceph_master {
  # CEPH DEPLOY SETUP 4, http://docs.ceph.com/docs/master/start/quick-start-preflight/
  file {'/etc/yum.repos.d/ceph.repo':
    ensure => 'present',
    source => 'puppet:///modules/ceph/ceph.repo',
  }
  #file {'/etc/yum.repos.d/ceph-deploy.repo':
  #  ensure => 'present',
  #  source => 'puppet:///modules/ceph/ceph.repo',
  #}
  # CEPH DEPLOY SETUP 5, http://docs.ceph.com/docs/master/start/quick-start-preflight/
  exec {'/bin/rpm --import https://download.ceph.com/keys/release.asc':}
  exec {'/bin/rpm --import https://download.ceph.com/keys/autobuild.asc':}
  package {'ceph-deploy':
    ensure => present,
  }
  exec {'/bin/ceph-deploy new cephmon1 cephmon2 cephmon3':
    user   => 'cephuser',
    group  => 'cephuser',
    cwd    => '/home/cephuser',
    unless => '/bin/grep "mon_initial_members = cephmon1, cephmon2, cephmon3" ceph.conf',
  }
  $osd_cephconf_lines = [
    "osd pool default size = 2",
    "osd pool default min size = 1",
    "osd pool default pg num = 256",
    "osd pool default pgp num = 256",
    "osd crush chooseleaf type = 1"
  ]
  $osd_cephconf_lines.each | $cephconf_line | {
    exec {"/bin/echo '$cephconf_line' >> ceph.conf":
      unless => "/bin/grep '$cephconf_line' ceph.conf",
      user  => 'cephuser',
      group => 'cephuser',
      cwd   => '/home/cephuser',
    }
  }
  $cephmembers = ["cephmon1", "cephmon2","cephmon3", "cephnode1", "cephnode2", "cephnode3", "cephmaster"]
  $cephmembers.each | $cephmember | {
    exec {"/bin/ceph-deploy install --release hammer $cephmember":
    #exec {"/bin/ceph-deploy install --release hammer '$cephmember'":
      unless => "/bin/ssh $cephmember 'yum list installed |grep ceph.x86_64'",
      user  => 'cephuser',
      group => 'cephuser',
      cwd   => '/home/cephuser',
    }
  }
  exec {'/bin/ceph-deploy mon create-initial':
    user   => 'cephuser',
    group  => 'cephuser',
    cwd    => '/home/cephuser',
    unless => '/bin/ls ceph.bootstrap-mds.keyring',
  }
  $cephnodes = ["cephnode1", "cephnode2", "cephnode3"]
  $cephnodes.each | $cephnode | {
    exec {"/bin/ceph-deploy osd prepare $cephnode:/var/local/osd":
      unless => "/bin/ssh $cephnode ls /var/local/osd/ceph_fsid",
      user  => 'cephuser',
      group => 'cephuser',
      cwd   => '/home/cephuser',
    }
    exec {"/bin/ceph-deploy osd activate $cephnode:/var/local/osd":
      unless => "/bin/ssh $cephnode grep ok /var/local/osd/active",
      user  => 'cephuser',
      group => 'cephuser',
      cwd   => '/home/cephuser',
    }
  }
  $cephmembers.each | $cephmember | {
    exec {"/bin/ceph-deploy admin '$cephmember'":
      unless => "/bin/ssh $cephmember 'ceph status'",
      user  => 'cephuser',
      group => 'cephuser',
      cwd   => '/home/cephuser',
    }
    exec {"/bin/ssh $cephmember 'sudo /usr/bin/chmod +r /etc/ceph/ceph.client.admin.keyring'":
      user  => 'cephuser',
      group => 'cephuser',
      cwd   => '/home/cephuser',
    }
  }
}
