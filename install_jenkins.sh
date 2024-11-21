#!/bin/bash

# Check the operating system
os_name=$(grep '^NAME=' /etc/os-release | cut -d '"' -f 2)

if [[ "$os_name" == "Amazon Linux"* ]]; then
    echo "Detected Amazon Linux. Proceeding with Jenkins installation for Amazon Linux."
    
    sudo yum update -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade -y
    sudo dnf install java-17-amazon-corretto -y
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo systemctl status jenkins

elif [[ "$os_name" == "Ubuntu"* ]]; then
    echo "Detected Ubuntu. Proceeding with Jenkins installation for Ubuntu."
    
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y fontconfig openjdk-17-jre
    sudo apt-get install -y jenkins
    sudo systemctl start jenkins
    sudo systemctl status jenkins
else
    echo "Unsupported operating system: $os_name"
    exit 1
fi

echo "Jenkins installation completed."
