Prerequisite:
- Centos7 system created with Vagrant and Virtualbox using vagrant/centos7/Vagrantfile.

Create learning vm:
- Download from 
- Import in virtualbox
- Add network Host only adapter, use vboxnet1 (same as vagrant centos7 system from prerequisite)
- Start vm

IP adres bepalen: 
- Logon with root
- # ip add
- Look for IP address with layout: 192.168.33.* 
  - If this is 192.168.33.100 no action required before 'vagrant up’
  - If other IP adres: change ip address of learning.puppetlabs.vm in vagrant/artifactory/Vagrantfile and vagrant/ceph/Vagrantfile

Add modules to puppet:
- Install ceph and artifactory module
  - Copy ceph.zip to /tmp
  - unzip /tmp/ceph.zip -d /
- puppet module install puppetlabs-ntp
- puppet module install saz-sudo
- puppet module install saz-timezone

Enable auto signing of certificates:
- vi /etc/puppetlabs/puppet/puppet.conf 
- add 'autosign = true’ in [master] section.

Create ceph node groups:
- Login to puppet, user/password = admin/puppetlabs
- Goto Nodes > Classification 
- Create groups
  - Ceph_master
    - Add rule: fact = fqdn, Operator = matches regex, value = cephmaster
    - Add classes: ceph::centos_basics, ceph::ceph_base
  - Ceph_monitors
    - Add rule: fact = fqdn, Operator = matches regex, value = cephmon
    - Add classes: ceph::centos_basics, ceph::ceph_base
  - Ceph_nodes
    - Add rule: fact = fqdn, Operator = matches regex, value = cephnode
    - Add classes: ceph::centos_basics, ceph::ceph_base, ceph::ceph_node
