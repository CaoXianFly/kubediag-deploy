# KubeDiag非容器化部署

## 部署过程:
整个部署过程分为两步：
```shell
# 1. 安装对应版本的Ansible
./install_ansible.sh

# 2. 执行部署程序
ansible-playbook -i inventory/hosts.ini deploy.yml
```

1. `./install_ansible.sh`:在控制节点（K3s节点）安装指定版本的Ansible以及对应版本的Python3和Pip3基础环境。同时还安装了后续用到的Ansible的kubernetes.core 模块；
2. `ansible-playbook -i inventory/hosts.ini deploy.yml`:开始执行整个部署过程（包括K3s节点和多个Agent节点），主要包括以下过程：
    * 在K3s节点安装Docker、K3s
    * 在K3s节点安装Kubediag
    * 读取配置参数inventory/group_vars/all/all.yml，并在Agents部署kubediag.service
    * 启动kubediag.service服务
## 卸载
3. `./uninstall`:卸载K3s节点以及Agents节点所有已经安装的程序和配置过的文件。

## 修改hosts
hosts文件位于inventory目录下，如果需要修改对应节点的ip，只需要修改此文件

## 修改参数
修改软件安装版本以及kubediag启动参数可以到inventory/hosts.ini deploy.yml文件进行修改