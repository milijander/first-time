#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible

sudo apt-get update
sudo apt-get install ansible



sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

#create devops group, grant sudo, grant ssh
groupadd admin
groupadd allowssh
echo "%admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "AllowGroups allowssh"  >> /etc/ssh/sshd_config

adduser ansible
usermod -G admin -a ansible
usermod -G allowssh -a ansible
mkdir /home/ansible/.ssh
mv /home/ansible/.ssh/novi.pub  /home/ansible/.ssh/authorized_keys

chown -R ansible /home/ansible/.ssh
chmod -R go-rwsx /home/ansible/.ssh

sed -i -e '/PasswordAuthentication yes/ s/yes/no/' /etc/ssh/sshd_config
sed -i '/^#.* PermitRootLogin /s/^#//' /etc/ssh/sshd_config
sed -i '/PermitRootLogin / s/yes/no/' /etc/ssh/sshd_config
