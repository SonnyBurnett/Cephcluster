# Cephcluster
Create Ceph Cluster using:

Prerequisite: puppet learning vm is available in Virtualbox using Host-only adapter with ip address 192.168.33.100

Vagrant is used for creating the Centos7 systems with as settings:
- network host-only adapter with ip adresses in the range 192.168.33.8x
- it will be connected to pupput on the learning.pupet.vm.

Puppet is used to provision the Ceph software and change configuration
