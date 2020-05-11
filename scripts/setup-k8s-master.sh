#!/bin/bash

set -euo pipefail

CALICO_VERSION=v3.13

IPADDR=$(ip a show enp0s8 | grep inet | grep -v inet6 | awk '{print $2}' | cut -f1 -d/)

sudo kubeadm init \
  --control-plane-endpoint="${IPADDR}:6443" \
  --apiserver-advertise-address="${IPADDR}" \
  --kubernetes-version="v1.18.0" \
  --pod-network-cidr="192.168.0.0/16" \
  --upload-certs

mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config

mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc

kubectl apply -f https://docs.projectcalico.org/${CALICO_VERSION}/manifests/calico.yaml

cat <<EOF | tee -a /share/join-worker.sh
#!/bin/bash
sudo $(kubeadm token create --print-join-command)
EOF
chmod +x /share/join-worker.sh 
