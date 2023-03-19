#!/bin/bash

username="ubuntu"

while getopts u: option
do
case "${option}" in
    u) username=${OPTARG}
        ;;
esac
done

export http_proxy=""
export https_proxy=""
export ftp_proxy=""
export no_proxy="127.0.0.1,localhost"

# For curl
export HTTP_PROXY=""
export HTTPS_PROXY=""
export FTP_PROXY=""
export NO_PROXY="127.0.0.1,localhost"

apt-get update -y
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

usermod -aG docker "$username"
newgrp docker

mkdir /etc/systemd/system/docker.service.d
cat <<EOT >> /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY="
Environment="HTTPS_PROXY="
Environment="NO_PROXY=localhost,127.0.0.0"
EOT

systemctl daemon-reload
systemctl restart docker