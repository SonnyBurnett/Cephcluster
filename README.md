# Cephcluster
Create Ceph OSD Cluster with:
- one Ceph master
- three Ceph monitors
- three Ceph osd nodes

Vagrant + Virtualbox are used for creating the Centos7 systems with settings:
- network host-only adapter with ip adresses in the range 192.168.33.8x
- and will be connected to pupput on the learning.pupet.vm.

Puppet is used to provision the Ceph software and change configuration

Prerequisites:
- Vagrant and Virtualbox installed on your system. 
- Puppetserver running in Virtualbox 
  - ipaddress 192.168.33.100
  - auto signing client certificates enabled
- Note: See prerequisites.txt if you need to create it.

Usage:
- Download the files from this repo as zip and unzip.
- Setup puppet environment, add aditional modules:
  - Copy the complete cephcluster/puppet/modules/ceph directory from the repo.zip to /etc/puppetlabs/code/environments/production/modules/ceph
  - puppet module install puppetlabs-ntp
  - puppet module install saz-sudo
  - puppet module install saz-timezone

- Create ceph node groups:
  - Login to puppet, user/password = admin/puppetlabs
  - Goto Nodes > Classification 
  - Create groups
    - Ceph_master
      - Add rule: fact = fqdn, Operator = matches regex, value = cephmaster
      - Add classes: ceph::centos_basics, ceph::ceph_base, ceph::ceph_master
    - Ceph_monitors
      - Add rule: fact = fqdn, Operator = matches regex, value = cephmon
      - Add classes: ceph::centos_basics, ceph::ceph_base
    - Ceph_nodes
      - Add rule: fact = fqdn, Operator = matches regex, value = cephnode
      - Add classes: ceph::centos_basics, ceph::ceph_base, ceph::ceph_node- 

- Setup vagrant environment:
  - Create a new ceph directory in your Vagrant folder.
  - Copy the file cephcluster/vagrant/ceph/Vagrantfile to the ceph directory. 
  - In the ceph directory run command 'vagrant up'.

Vagrant will now spin up de systems and Puppet will provision ceph on it.

Known bugs:
- 'ceph_deploy install ..' and 'ceph_deploy ..' admin fails on cephmaster. Workaround:
  - On cephmaster run as cephuser (password 87654321) the following commands:
    - 'ceph-deploy install --no-adjust-repos cephmaster', note: During puppet agent –t > [WARNING] You need to be root to perform this command.
    - 'ceph-deploy admin cephmaster', note: During puppet agent –t > [ERROR ] OSError: [Errno 13] Permission denied: '/etc/ceph/tmp1275fY'
  - On cephmaster as root run 'puppet agent -t'.
 
