class ceph::centos_basics {
  # update system
  exec {'/bin/yum -y update':}
  # install basics for centos
  exec {'/bin/yum install -y vim':}
  exec {'/bin/yum install -y rpm':}
  exec {'/bin/yum install -y wget':}
  # Make sure all the clocks on the nodes are synchronised
  # set timezone to Europe/Amsterdam
  class { 'timezone':
    timezone => 'Europe/Amsterdam',
  }
  # install ntp: syncs system clock with ntp time servers
  exec {'/bin/yum install -y ntp ntpdate ntp-doc':}
  # make hardware clock sync with ntp
  file {'/etc/sysconfig/ntpdate':
    ensure => 'present',
    source => 'puppet:///modules/ceph/ntpdate'
  }
  # running ntpdate when ntpd is enable gives error
  # exec {'/sbin/ntpdate 0.centos.pool.ntp.org':}
  exec {'/usr/bin/systemctl enable ntpd.service':}
  exec {'/usr/bin/systemctl start ntpd.service':}
  # Install an SSH server (if necessary)
  exec {'/bin/yum install -y openssh-server':}
}
