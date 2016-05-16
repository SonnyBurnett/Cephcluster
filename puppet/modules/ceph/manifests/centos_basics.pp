class ceph::centos_basics {
  # update system
  # exec {'/bin/yum -y update':}
  # install basics for centos
  package { 'vim':
    ensure    => installed,
  }
  package { 'rpm':
    ensure    => installed,
  }
  package { 'wget':
    ensure    => installed,
  }
  # Make sure all the clocks on the nodes are synchronised
  # set timezone to Europe/Amsterdam
  class { 'timezone':
    timezone => 'Europe/Amsterdam',
  }
  # install ntp: syncs system clock with ntp time servers
  package { 'ntp':
    ensure    => installed,
  }
  package { 'ntpdate':
    ensure    => installed,
  }
  package { 'ntp-doc':
    ensure    => installed,
  }
  # make hardware clock sync with ntp
  file {'/etc/sysconfig/ntpdate':
    ensure => 'present',
    source => 'puppet:///modules/ceph/ntpdate'
  }
  # running ntpdate when ntpd is enable gives error
  # exec {'/sbin/ntpdate 0.centos.pool.ntp.org':}
  #exec {'/usr/bin/systemctl enable ntpd.service':}
  #exec {'/usr/bin/systemctl start ntpd.service':}
  service {'ntpd.service':
    ensure  => running,
    enable  => true,
  }
  # Install an SSH server (if necessary)
  package { 'openssh-server':
    ensure    => installed,
  }
}
