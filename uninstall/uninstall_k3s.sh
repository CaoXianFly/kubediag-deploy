#!/bin/bash
rm -rf ~/.kube/*
sh /usr/local/bin/k3s-uninstall.sh

apt-get remove docker docker-engine docker.io containerd runc -y

yum remove -y docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine \
                podman \
                runc