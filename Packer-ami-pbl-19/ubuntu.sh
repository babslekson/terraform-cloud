#!/bin/bash

# Update package lists
sudo apt-get update

# Install required build tools and utilities
sudo apt-get install -y build-essential dpkg-dev software-properties-common

# Add additional repositories
sudo add-apt-repository universe
sudo add-apt-repository multiverse

# Update package lists again after adding new repositories
sudo apt-get update

# Install Java 17
sudo apt-get install -y openjdk-17-jre openjdk-17-jdk

# Install MySQL client
sudo apt-get install -y mysql-client-core-8.0

# Install other required packages
sudo apt-get install -y git wget vim telnet htop python3 chrony iproute2

# Clean up
sudo apt-get autoremove -y
