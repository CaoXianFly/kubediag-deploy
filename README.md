# KubeDiag非容器化部署

## 自定义修改

### 1. 修改hosts

hosts文件位于inventory目录下，如果需要修改对应节点的ip，只需要修改此文件。同时还需要注意修改所有agents节点的`ansible_user`，该字段表示的是远程连接agents节点的用户名。

### 2. 启动参数设置

修改软件安装版本以及kubediag启动参数可以到inventory/groups_vars/all/all.yml文件进行修改。包括K3s和Docker安装版本设置以及kubediag service启动参数设置。

## 部署过程

### 前提

首先保证当前节点（k3s-server）的公钥已经被添加至hosts列出的所有节点，包括k3s-server节点本身。

```shell

# 1. 推荐使用ssh-agent管理控制节点
eval ssh-agent
# 2. 将私钥交由ssh-agent进行管理
ssh-add ~/.ssh/id_rsa
# 3. 拷贝本地公钥到所有节点
ssh-copy-id -i ~/.ssh/id_rsa.pub user@ip
```

### 部署过程如下

```shell
# 1. 安装对应版本的Ansible
./install_ansible.sh

# 2. 激活虚拟环境
source kubediag-env/bin/activate

# 3. 执行部署程序
ansible-playbook -i inventory/hosts.ini deploy.yml
```

1. `./install_ansible.sh`:为了保证环境隔离，创建了`kubediag-env`这个python虚拟环境，所需依赖都安装在此环境中。在控制节点（K3s节点）安装指定版本的Ansible以及对应版本的Python3和Pip3基础环境。
2. `ansible-playbook -i inventory/hosts.ini deploy.yml`:开始执行整个部署过程（包括K3s节点和多个Agent节点），主要包括以下过程：
    * 在K3s节点安装Docker、K3s
    * 在K3s节点安装Kubediag
    * 读取配置参数inventory/group_vars/all/all.yml，并在Agents部署kubediag.service
    * 启动kubediag.service服务

## 卸载

3. `./uninstall`:卸载K3s节点以及Agents节点所有已经安装的程序和配置过的文件。
