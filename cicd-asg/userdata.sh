#!/bin/bash
sudo apt install wget -y
cd /home/ubuntu
sudo apt install ruby-full -y
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto