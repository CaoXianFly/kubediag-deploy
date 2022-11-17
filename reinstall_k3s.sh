#!/bin/bash
rm -rf ~/.kube/*
bash /usr/local/bin/k3s-uninstall.sh

export INSTALL_K3S_VERSION=v1.20.15+k3s1
curl -sfL https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config