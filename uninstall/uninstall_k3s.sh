#!/bin/bash
rm -rf ~/.kube/*
sh /usr/local/bin/k3s-uninstall.sh

# # Uninstall docker on Ubuntu
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)

# sudo apt-get remove docker docker-ce docker-ce-* docker-engine docker.io containerd runc -y
# sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
# sudo rm -rf /var/lib/docker
# sudo rm -rf /var/lib/containerd

# # Uninstall docker on CentOS
# sudo yum remove -y docker \
#                 docker-client \
#                 docker-client-latest \
#                 docker-common \
#                 docker-latest \
#                 docker-latest-logrotate \
#                 docker-logrotate \
#                 docker-engine \
#                 podman \
#                 runc

# sudo yum remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# sudo rm -rf /var/lib/docker
# sudo rm -rf /var/lib/containerd