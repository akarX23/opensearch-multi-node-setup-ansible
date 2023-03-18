#!/bin/bash

username="ubuntu"

while getopts u: option
do
case "${option}" in
    u) username=${OPTARG}
        ;;
esac
done

apt install python3-pip zip unzip -y

curl -s "https://get.sdkman.io" | bash
cp ~/.sdkman "/home/$username"
source ~/.sdkman/bin/sdkman-init.sh

sdk install java 14.0.2-open
sdk use java 14.0.2-open

echo "n" | sdk install java 11.0.17-amzn
echo "n" | sdk install java 8.0.362-amzn

echo "export JAVA_HOME=/home/$username/.sdkman/candidates/java/current" >> "/home/$username/.zshrc"
echo "export JAVA14_HOME=/home/$username/.sdkman/candidates/java/14.0.2-open" >> "/home/$username/.zshrc"
echo "export JAVA11_HOME=/home/$username/.sdkman/candidates/java/11.0.17-amzn" >> "/home/$username/.zshrc"
echo "export JAVA8_HOME=/home/$username/.sdkman/candidates/java/8.0.362-amzn" >> "/home/$username/.zshrc"
echo "export PATH=/home/$username/.local/bin:$PATH" >> "/home/$username/.zshrc"

sudo -u "$username" pip3 install opensearch-benchmark