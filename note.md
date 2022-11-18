1. 安装k3s是如果k3s存在的话则不会重新安装，只会重新拷贝文件和验证k3s工作正常

2. 安装kubediag的话，是默认删除已经存在的内容，重新安装包括Docker、cert-manager namespace 和 kubediag的安装都是删了重新安装

3. github下载地址现在全部换成了gitee，后面还要进行统一换做一个新的地址。包括：
* cert-manger.yaml下载
* kubediag下载
* 在install_ansible.sh脚本中安装kubernetes.core的时候换做了gitee源头