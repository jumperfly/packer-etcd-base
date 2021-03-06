pipeline {
    agent any

    options {
        ansiColor('xterm')
    }

    environment {
        VAGRANT_CLOUD_TOKEN = credentials('vagrant-cloud')
        BASE_BOX_VERSION = "7.7.3"
        ETCD_MAJOR_MINOR = "3.3"
        ETCD_PATCH = "15"
    }

    stages {
        stage('Clean') {
            steps {
                sh 'rm -rf roles output-*'
                sh 'if vagrant box list | grep packer_etcd; then vagrant box remove packer_etcd; fi'
            }
        }
        stage ('Download Base Box') {
            when { 
                expression { return !fileExists("$HOME/.vagrant.d/boxes/jumperfly-VAGRANTSLASH-centos-7/$BASE_BOX_VERSION/virtualbox/box.ovf") }
            }
            steps {
                sh "vagrant box add jumperfly/centos-7 --box-version $BASE_BOX_VERSION"
            }
        }
        stage('Build Base') {
            steps {
                sh 'packer build etcd-base.json'
            }
        }
        stage('Build') {
            steps {
                sh 'packer build etcd.json'
            }
        }
    }
}
