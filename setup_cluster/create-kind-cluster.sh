#!/bin/bash

# Check the architecture of the system 
if [ "$(uname -m)" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$(uname -m)" = "aarch64" ]; then
    ARCH="arm64"
else
    echo "Unsupported architecture"
    exit 1
fi

# Define the cluster name
CLUSTER_NAME='ignitedotdev'

KUBECTL="kubectl"
DOCKER="docker"

KUBECTL_LATEST_RELEASE_URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$ARCH/kubectl"
KUBECTL_CHECKSUM_URL="https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "Creating kind cluster..."

# Check if docker is installed
dpkg -s $DOCKER &> /dev/null

if [ $? -eq 0 ]; then
    echo "$DOCKER is installed, moving on ..."
else
    echo "Installing $DOCKER ..."
    
    # Remove clashing packages
    sudo apt remove --yes docker docker-engine docker.io containerd runc || true
    sudo apt update
    sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
    wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository --yes "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
    sudo apt update
    sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
    sudo usermod --append --groups docker "$USER"
    sudo systemctl enable docker
    echo "Docker successfully installed"
   
    sleep 5

    # Get Docker Compose - bonus
    echo "Installing Docker Compose ..."
    sudo wget --output-document=/usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/$(wget --quiet --output-document=- https://api.github.com/repos/docker/compose/releases/latest | grep --perl-regexp --only-matching '"tag_name": "\K.*?(?=")')/run.sh"
    sudo chmod +x /usr/local/bin/docker-compose
    sudo wget --output-document=/etc/bash_completion.d/docker-compose "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose"
    echo "Docker Compose successfully installed"
fi

# Check if kubectl is installed
dpkg -s $KUBECTL &> /dev/null

if [ $? -eq 0 ]; then
    echo "$KUBECTL is installed, moving on ..."
else
    echo "Installing $KUBECTL ..."

    # Download the latest kubectl release for your architecture
    curl -LO "$KUBECTL_LATEST_RELEASE_URL"

    # Install kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

# Install kind
kind create cluster --name $CLUSTER_NAME

# Select the config file to be used for this cluster (the one just created by kind)
kubectl config use-context $CLUSTER_NAME
kubectl cluster-info --context kind-$CLUSTER_NAME

echo "Kind cluster successfully created"
