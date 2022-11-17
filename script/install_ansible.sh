#!/bin/sh
if which ansible; then
    ansible -V
    echo "====> { Ansible has been installed }"
    # exit 0
fi

# Install python3 and pip3
PY3_VERSION=6
if which python3; then
    PY3_VERSION=`python3 -V 2>&1|awk '{print $2}'|awk -F '.' '{print int($2)}'`
    echo $PY3_VERSION
    # Install pip3
    if which pip3; then
        echo "====> { pip3 has been installed! }"
    else 
        if which apt; then
            apt install python3-pip -y
        elif which yum; then
            yum install python3-pip -y
        else
            echo "====> { Unknown package manager! }"
        # curl https://bootstrap.pypa.io/pip/3.${PY3_VERSION}/get-pip.py -o get-pip.py
        # python3 get-pip.py
        fi
        if which pip3; then
            echo "====> { pip3 is installed successfully! }"
        else 
            echo "====> { pip3 install failed! }"
            exit -1
        fi
    fi
else
    # Install openssl-devel
    if which openssl; then
        echo "====> { openssl-devel has been installed! }"
    else
        sudo yum install openssl-devel -y
    
        sudo apt-get install openssl
        sudo apt-get install libssl-dev
        if which openssl; then
            echo "==== > { openssl-dev installed successfully! }"
        else
            echo "==== > { openssl-devel installed failed! }"
            exit -1
        fi
    fi
    INSTALL_PREFIX=/usr/local/python3.6.8
    # Python3.6.8 now
    wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz
    tar -xzvf Python-3.6.8.tgz
    cd Python-3.6.8
    ./configure --prefix=$INSTALL_PREFIX
    if [ $? -eq 0 ]; then
        echo "====> { Python install success and will configure }"
    else 
        echo "====> { Python install failed and exit -1 }"
        exit -1
    fi
    make && make install
    # Override old softlink, please use `-b` para.
    ln -sb ${INSTALL_PREFIX}/bin/* /usr/bin
    echo "====> { Python3.6.8 installed successfully! }"
fi

# No support python3.11 or later version
ANSIBLE_VERSION=2.11
if [ $PY3_VERSION -ge 10 ]; then
    ANSIBLE_VERSION=2.12
fi
echo "====> { Ansible$ANSIBLE_VERSION will be installed on local }"

# Start install Ansible
# VENVDIR=kubediag-deploy-venv
# KUBEDIAGDIR=kubediag
# pip3 install virtualenv
# if [ $? -eq 0 ]; then
#     echo "====> { virtaulenv installed! }"
# else 
#     echo "====> { virtualenv installe failed! }"
#     exit -1
# fi
# virtualenv --python=$(which python3) $VENVDIR
# source $VENVDIR/bin/activate
# cd $KUBEDIAGDIR
pip3 install --upgrade pip
pip3 install -U -r requirements-$ANSIBLE_VERSION.txt

if which ansible; then
    echo "====> { Ansible$ANSIBLE_VERSION is installed successfully! }"
else
    echo "====> { Ansible install failed and exit with -1}"
    exit -1
fi

# Install ansible kubernetes module
# see at https://github.com/ansible-collections/kubernetes.core/issues/159#issuecomment-873920322
pip install --ignore-installed kubernetes

kubernetes_core_dir=~/kubernetes.core
if [ $? -eq 0 ]; then
    # not exist
    if [ ! -d "$kubernetes_core_dir" ]; then
        # TODO: Clone fail sometime because of network to github
        #       We provide a gitee mirror for domestic users
        echo "===> { kubernetes.core directory is not exist, git cloning but maybe fail because of network... }"
        # git clone https://github.com/ansible-collections/kubernetes.core.git ~/kubernetes.core
        git clone https://gitee.com/codercxf/kubernetes.core.git ~/kubernetes.core
        # if [ $? -ne 0 ]; then
        #     git clone https://gitee.com/codercxf/kubernetes.core.git ~/kubernetes.core
        # fi
        # clone failed finally 
        if [ ! -d "$kubernetes_core_dir" ]; then
            echo "$kubernetes_core_dir is not exist" 
            echo "====> { git clone failed and exit with -1 }"
            exit -1
        fi
    fi
        mkdir -p ~/.ansible/plugins/modules
        cp ~/kubernetes.core/plugins/action/k8s.py ~/.ansible/plugins/modules/
        ansible-galaxy collection install kubernetes.core
        rm -rf ~/kubernetes.core
        # rm -rf ~/kubernetes.core
        if [ $? -eq 0 ]; then
            echo "====> { Ansible module kubernetes.core installed success }"
        else
            echo "====> { Ansible module kubernetes.core install failed and exit -1 }"
            exit -1
        fi
        
else
    echo "====> { Ansible module kubernetes.core install failed and exit -1 }"
    exit -1
fi