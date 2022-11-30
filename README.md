# KubeDiag非容器化部署

## 自定义修改

### 1. 修改hosts

hosts文件位于inventory目录下，如果需要修改对应节点的ip，只需要修改此文件。同时还需要注意修改所有master和agent节点的`ansible_user`字段，该字段表示的是远程连接这些节点的用户名。

### 2. 启动参数设置

修改kubediag service和kubediag master service启动参数可以到inventory/groups_vars/all/all.yml文件进行修改。

## 部署过程

### 前提

1. 首先保证当前节点（k3s-server）的公钥已经被添加至其他列出的所有节点中的`authorized_keys`文件。

    ```shell
    ssh-copy-id -i ~/.ssh/id_rsa.pub user@ip
    ```

    使用下面命令判断所有控制节点网络是否可达：

    ```shell
    ansible -i inventory/hosts.ini all -m ping
    ```

2. 保证Ansible已经安装可用，如果没有安装则使用如下命令进行安装：

    ```shell
    # 1. 安装Ansible
    ./install_ansible.sh

    # 2. 激活虚拟环境
    source kubediag-env/bin/activate
    ```

    为了使得环境隔离，Ansible是在安装在python虚拟环境中。

### 部署过程如下

```shell
# 执行部署程序
ansible-playbook -i inventory/hosts.ini deploy.yml
```

`ansible-playbook -i inventory/hosts.ini deploy.yml`：开始执行整个部署过程（包括K3s节点和多个Agent节点），主要包括以下过程：

* 在K3s节点安装K3s以及部署kubediag元数据；
* 读取配置参数inventory/group_vars/all/all.yml，并在master节点部署kubediag-master.service；
* 读取配置参数inventory/group_vars/all/all.yml，并在agents节点部署kubediag.service；
* 分别启动kubediag-master service和kubediag.service服务。

## 卸载

`./uninstall.sh`：卸载K3s节点以及master和agent节点所有已经安装的程序和配置文件。
