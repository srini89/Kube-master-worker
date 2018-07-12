#!/bin/bash
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
    apt-transport-https \
    ca-certificates \
    curl \
    dialog \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce=17.09.0~ce-0~ubuntu kubelet=1.8.4-00 kubeadm=1.8.4-00 kubectl=1.8.4-00 kubernetes-cni=0.5.1-00
