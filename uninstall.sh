#!/bin/sh
./uninstall/uninstall_k3s.sh
ansible-playbook -i inventory/hosts.ini ./uninstall/uninstall_agent_env.yml