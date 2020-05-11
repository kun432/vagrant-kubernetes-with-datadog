# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.synced_folder "./share", "/share" , type: "virtualbox"

  # always before setting up worker nodes
  config.vm.define "master" do |c|
    c.vm.hostname = "master.internal"
    c.vm.network "private_network", ip: "10.240.0.11"
    c.vm.provider "virtualbox" do |v|
      v.gui = false
      v.cpus = 2
      v.memory = 2048
    end

    c.vm.provision :shell, :path => "scripts/setup-initial-ubuntu.sh"
    c.vm.provision :shell, :path => "scripts/setup-docker-ubuntu.sh"
    c.vm.provision :shell, :path => "scripts/setup-k8s.sh"
    c.vm.provision :shell, :path => "scripts/setup-k8s-master.sh"
  end

  (1..2).each do |n|
    config.vm.define "worker-#{n}" do |c| c.vm.hostname = "worker-#{n}.internal"
      c.vm.network "private_network", ip: "10.240.0.2#{n}"
      c.vm.provider "virtualbox" do |v|
        v.gui = false
        v.cpus = 1
        v.memory = 1024
      end

      c.vm.provision :shell, :path => "scripts/setup-initial-ubuntu.sh"
      c.vm.provision :shell, :path => "scripts/setup-docker-ubuntu.sh"
      c.vm.provision :shell, :path => "scripts/setup-k8s.sh"
      c.vm.provision :shell, :path => "scripts/setup-k8s-worker.sh"
    end
  end
  
end
