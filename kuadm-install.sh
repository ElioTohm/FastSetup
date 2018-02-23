# !/bin/bash

#########################################################################
# Ubuntu 64 setup                                                       #
#########################################################################
function installonX64 {
  #  First install Docker from the docker repofor ubuntu and debian
  # update packages
  apt-get update
  # upgrade unit
  apt-get upgrade
  # install prerequisites
  apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
  # add docker key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  # add repo
  add-apt-repository \
     "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
     $(lsb_release -cs) \
     stable"
  # update packages and install
  apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

  # install https package
  apt-get update && apt-get install -y apt-transport-https

  # add google package key
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

  # add repo to package list
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

  # update package list
  apt-get update
  # install kubernetes ctl and adm
  apt-get install -y kubelet kubeadm kubectl
}

#########################################################################
# Raspbian setup                                                        #
#########################################################################
function installonARMv8 {
  #docker installation
  apt-get install \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg2 \
       software-properties-common

  # add repo keys
  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
  apt-key fingerprint 0EBFCD88

  # add docker repo for armhf
  echo "deb [arch=armhf] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
       $(lsb_release -cs) stable" | \
      tee /etc/apt/sources.list.d/docker.list

  # update repo list
  apt-get update

  # install docker
  apt-get install docker-ce
  # add user to docker group
  usermod pi -aG docker

  # Turn off swap for kubernetes to work
  dphys-swapfile swapoff && \
  dphys-swapfile uninstall && \
  update-rc.d dphys-swapfile remove

  echo "cgroup_enable=cpuset cgroup_enable=memory" >> /boot/cmdline.txt

  # Add repo lists & install kubeadm
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
  apt-get update -q && \
  apt-get install -qy kubeadm
}

#########################################################################
# Read user input                                                       #
#########################################################################
for i in "$@"
do
case $i in
    -r=*|--role=*)
    ROLE="${i#*=}"
    shift # past argument=value
    ;;
esac
done

#########################################################################
# Check Architecture                                                    #
#########################################################################
ARCH=$(dpkg --print-architecture)

if [ $ARCH == "amd64" ]
then
  installonX64
elif [ $ARCH == "armhf" ] 
then
  installonARMv8
else
  echo Architecture not yet supported  
fi

#########################################################################
# setm kb8s instance as master                                          #
#########################################################################
if ["${ROLE}" == "master"] then
  # master we need to initialize the network
  # first we inti the master node
  kubeadm init

  # we specify the pod network
  # here we are using Calcio
  kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
fi

