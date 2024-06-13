#!/bin/bash
#Installation of Java

sudo apt update
sudo apt install fontconfig openjdk-17-jre

# Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

# Start Jenkins service and enable it to start at boot
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose

# Verify Docker installation by running hello-world image
sudo docker run -d  hello-world
#Add Jenkins User to Docker Group
sudo usermod -aG docker jenkins
#Then restart the Jenkins service:
sudo systemctl restart jenkins
#Adjust Docker Socket Permissions
sudo chmod 666 /var/run/docker.sock
#Verify Docker Installation and Permissions
sudo su - jenkins
docker ps -a
