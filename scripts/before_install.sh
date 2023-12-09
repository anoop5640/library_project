#!/usr/bin/env bash

# Clean codedeploy-agent files for a fresh install
sudo rm -rf /home/ubuntu/install

# Update and install necessary packages
sudo apt-get -y update
sudo apt-get -y install ruby wget nginx

# Install CodeDeploy agent
wget https://aws-codedeploy-eu-west-1.s3.amazonaws.com/latest/install
sudo chmod +x ./install 
sudo ./install auto

# Update OS and install Python 3 and its dependencies
sudo apt-get -y update
sudo apt-get -y install python3 python3-dev python3-pip python3-venv
pip install --user --upgrade virtualenv

# Delete existing application (if any)
sudo rm -rf /home/ubuntu/library_project
