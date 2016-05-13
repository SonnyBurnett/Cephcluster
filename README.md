# Cephcluster
Create Ceph Cluster using:

Vagrant is used for creating the Centos7 systems with as settings:
- network host-only adapter with ip adresses in the range 192.168.33.8x
- it will be connected to pupput on the learning.pupet.vm.

Puppet is used to provision the Ceph software and change configuration

Usage:
- Setup puppet according to puppet/readme.txt
- Use Vagrant to create the Ceph cluster with the file vagrant/ceph/Vagrantfile
 
