#!/bin/bash
# Update the package list and install necessary dependencies
apt update -y
apt install -y software-properties-common

# Add the Ansible PPA (Personal Package Archive)
add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
apt update -y
apt install -y ansible

# Verify Ansible installation
ansible --version
