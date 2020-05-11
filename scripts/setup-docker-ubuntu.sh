#!/bin/bash

set -euo pipefail

DOCKER_VERSION=5:19.03.8~3-0~ubuntu-bionic
CONTAINERD_VERSION=1.2.13-1

# install docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc 
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io=${CONTAINERD_VERSION}
sudo systemctl enable docker && sudo systemctl start docker
sudo usermod -aG docker vagrant
sudo apt-mark hold docker-ce docker-ce-cli containerd.io

# cgoup
sudo mkdir -p /etc/docker
cat <<'EOF' | sudo tee -a /etc/docker/daemon.json
{
  "insecure-registries": ["gitlab.internal:5001"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

# Restart Docker
sudo systemctl daemon-reload
sudo systemctl restart docker