#!/bin/bash

## Script to run a test build locally - parses Jenkinsfile for latest configuration
eval $(egrep 'BASE_BOX_VERSION =|ETCD_MAJOR_MINOR =|ETCD_PATCH =' Jenkinsfile | awk '{ print "export " $1 $2 $3 }')
BOX_ADD_CMD=$(grep 'box add' Jenkinsfile | sed 's/.*sh "\([^"]\+\)"/\1/')
if [ ! -f $HOME/.vagrant.d/boxes/jumperfly-VAGRANTSLASH-centos-7/$BASE_BOX_VERSION/virtualbox/box.ovf ]; then
  $BOX_ADD_CMD
fi
rm -rf roles output-*
vagrant box list | grep packer_etcd && vagrant box remove packer_etcd
packer build -except=vagrant-cloud etcd-base.json
packer build -except=vagrant-cloud etcd.json
