class ceph::ceph_master {
  # !!!!!!! Work in progress not finished yet !!!!!!!

  # Generic stuff
  # Update system
  exec {'/bin/yum -y update':}
  # Install some basics
  exec {'/bin/yum install -y vim':}
  exec {'/bin/yum install -y rpm':}
  exec {'/bin/yum install -y wget':}
  #
  # CEPH install
  # Install elrepo
  exec {'/bin/rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org':}
  exec {'/bin/rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm':}
  exec {"/bin/sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/elrepo.repo":}
  # CEPH DEPLOY SETUP 3, http://docs.ceph.com/docs/master/start/quick-start-preflight/
  exec {'/bin/yum install -y yum-utils':}
  exec {'/bin/yum-config-manager --add-repo https://dl.fedoraproject.org/pub/epel/7/x86_64/':}
  exec {'/bin/yum install --nogpgcheck -y epel-release':}
  exec {'/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7':}
  exec {'/bin/rm /etc/yum.repos.d/dl.fedoraproject.org*':}
  # CEPH DEPLOY SETUP 4, http://docs.ceph.com/docs/master/start/quick-start-preflight/
  file {'/etc/yum.repos.d/ceph.repo':
    ensure => 'present',
    source => 'puppet:///modules/ceph/ceph.repo',
  }
  # CEPH DEPLOY SETUP 5, http://docs.ceph.com/docs/master/start/quick-start-preflight/
  exec {'/bin/yum -y update':}
  exec {'/bin/yum install -y ceph-deploy':}
  # Make sure the Master can find the nodes
  class {'ceph::hosts':
    fqdn     => $fqdn,
    hostname => $hostname,
  }
  
  
  
  
  exec {'/bin/yum install -y ntp ntpdate ntp-doc':}
  exec {'/bin/yum install -y yum-plugin-priorities':}
  exec {'/sbin/setenforce 0':}
  exec {'/bin/systemctl disable firewalld':}
  include ceph::privileges
}
