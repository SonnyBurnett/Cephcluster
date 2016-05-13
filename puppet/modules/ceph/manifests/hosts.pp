class ceph::hosts ( $fqdn, $hostname ) {
  $str = 
"127.0.0.1   ${fqdn} ${hostname} localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.33.100 learning.puppetlabs.vm
192.168.33.80 cephmaster.cluster1 cephmaster
192.168.33.81 cephmon1.cluster1 cephmon1
192.168.33.82 cephmon2.cluster1 cephmon2
192.168.33.83 cephmon3.cluster1 cephmon3
192.168.33.84 cephnode1.cluster1 cephnode1
192.168.33.85 cephnode2.cluster1 cephnode2
192.168.33.86 cephnode3.cluster1 cephnode3
"
  file { "/etc/hosts":
    content => "$str",
  }
}
