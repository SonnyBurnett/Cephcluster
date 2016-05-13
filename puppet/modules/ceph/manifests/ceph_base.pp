class ceph::ceph_base {
  exec {'/bin/yum install -y yum-plugin-priorities':}
  exec {'/sbin/setenforce 0':}
  exec {'/bin/systemctl disable firewalld':}

  # Make sure all nodes can find each other using /etc/hosts
  class {'ceph::hosts':
    fqdn     => $fqdn,
    hostname => $hostname,
  }

  # create cephuser, add cephuser and vagrant to sudoers
  include ceph::privileges
}
