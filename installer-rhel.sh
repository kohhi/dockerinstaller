#!/bin/sh
COMPOSE_VERSION="1.25.4"

###### Password
if ! ${PASSWORD+:} false; then
  printf "Enter Password: "
  read -s PASSWORD
fi

###### Install dnf
if [ "$(cat /etc/redhat-release | grep -o [0-9]\.[0-9] | tr -d .)" -lt "80" ]; then
  echo "${PASSWORD}" | sudo -S yum -y install dnf
fi

###### Install Docker
echo "Uninstalling Old Docker Package..."
echo "${PASSWORD}" | sudo -S dnf -y remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine docker-ce docker-ce-cli containerd.io
echo "Installing dnf-plugins-core..."
echo "${PASSWORD}" | sudo -S dnf -y install dnf-plugins-core
echo "Adding Docker Repository..."
echo "${PASSWORD}" | sudo -S dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo "Installing Docker..."
echo "${PASSWORD}" | sudo -S dnf -y install docker-ce docker-ce-cli containerd.io

###### Install Docker Compose
echo "Installing docker-compose..."
echo "${PASSWORD}" | sudo -S curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
echo "${PASSWORD}" | sudo -S chmod +x /usr/local/bin/docker-compose

###### Start Docker
echo "Starting Docker..."
echo "${PASSWORD}" | sudo -S systemctl start docker
echo "${PASSWORD}" | sudo -S systemctl enable docker
echo "${PASSWORD}" | sudo -S gpasswd -a $(whoami) docker