class ceph::ceph_base {
  package { 'yum-plugin-priorities':
    ensure    => installed,
  }
  # exec {'/bin/yum install -y yum-plugin-priorities':}
  # in ceph/centos7 vagrant box is SELinux disabled, setenforce 0 gives error so disabled
  # exec {'/sbin/setenforce 0':}
  service {'firewalld':
    ensure  => stopped,
    enable  => false,
  }

  # Make sure all nodes can find each other using /etc/hosts
  class {'ceph::hosts':
    fqdn     => $fqdn,
    hostname => $hostname,
  }

  # create cephuser, add cephuser and vagrant to sudoers
  include ceph::privileges
  # Install elrepo
  exec {'/bin/rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org':}
  exec { 'install-elrepo-release-7':
    command => '/bin/rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm',
    unless  => '/bin/rpm -q elrepo-release-7.0-2.el7.elrepo.noarch',
  }
  exec {"/bin/sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/elrepo.repo":}
  # CEPH DEPLOY SETUP 3, http://docs.ceph.com/docs/master/start/quick-start-preflight/
  package { 'yum-utils':
    ensure => installed,
  }
  yumrepo { 'dl.fedoraproject.org':
    enabled  => 1,
    descr    => 'Repo dl.fedoraproject.org',
    baseurl  => 'https://dl.fedoraproject.org/pub/epel/7/x86_64/',
    gpgcheck => 0,
  }
  package { 'epel-release':
    ensure => installed,
    install_options => '--nogpgcheck',
  }
  exec {'/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7':}
  exec {'/bin/rm /etc/yum.repos.d/dl.fedoraproject.org*':}
}
