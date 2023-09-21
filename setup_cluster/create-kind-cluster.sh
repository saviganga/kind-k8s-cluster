#!/bin/bash

arm=("arm64" "aarch64")
amd=("amd64")

if echo "${arm[@]}" | grep -qw "$(uname -m)"; then
    ARCH="arm64"
elif echo "${amd[@]}" | grep -qw "$(uname -m)"; then
    ARCH="amd64"
else
    echo "Unsupported architecture"
    exit 1
fi


# # Check the architecture of the system 
# if [ "$(uname -m)" = "x86_64" ]; then
#     ARCH="amd64"
# elif [ "$(uname -m)" = "aarch64" ]; then
#     ARCH="arm64"
# else
#     echo "Unsupported architecture"
#     exit 1
# fi

# ARCH=$(uname -m)

echo " $ARCH "

# Define the cluster name
CLUSTER_NAME='ignitedotdev'

KUBECTL="kubectl"
DOCKER="docker"

KUBECTL_LATEST_RELEASE_URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$ARCH/kubectl"
KUBECTL_CHECKSUM_URL="https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "Creating kind cluster..."

# Check if Docker is installed
# dpkg -s $DOCKER &> /dev/null

if ! command -v $DOCKER &>/dev/null; then
    echo "$DOCKER is installed, moving on ..."
else
    echo "Installing $DOCKER ..."

    # Remove clashing packages
    sudo apt remove --yes "docker docker-engine docker.io containerd runc" || true
    
    # Add Docker APT repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=$ARCH] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge"
    
    apt-cache policy docker-ce

    sudo apt-get install -y docker-ce
    # sudo systemctl status docker

    # Update APT cache and install Docker
    sudo apt update
    sudo apt --yes --no-install-recommends install "docker-ce docker-ce-cli containerd.io"
    
    # Add the current user to the Docker group
    sudo usermod --append --groups docker "$USER"
    
    # Enable Docker service
    sudo systemctl enable docker
    
    echo "Docker successfully installed"
   
    sleep 5

    # Check if Docker Compose is installed
    if ! command -v docker-compose &>/dev/null; then
        echo "Installing Docker Compose ..."
        sudo wget --output-document=/usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/$(wget --quiet --output-document=- https://api.github.com/repos/docker/compose/releases/latest | grep --perl-regexp --only-matching '"tag_name": "\K.*?(?=")')/run.sh"
        sudo chmod +x /usr/local/bin/docker-compose
        sudo wget --output-document=/etc/bash_completion.d/docker-compose "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose"
        echo "Docker Compose successfully installed"
    else
        echo "Docker Compose is already installed..."
    fi
fi

# Check if kubectl is installed
dpkg -s $KUBECTL &> /dev/null

if ! command -v $KUBECTL &> /dev/null; then
    echo "$KUBECTL is installed, moving on ..."
else
    echo "Installing $KUBECTL ..."

    # Download the latest kubectl release for your architecture
    curl -LO "$KUBECTL_LATEST_RELEASE_URL"

    # Install kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

if kind get clusters | grep -q "$CLUSTER_NAME"; then
    echo "Deleting existing cluster with clashing name"
    kind delete cluster --name $CLUSTER_NAME
else
    # Install kind
    kind create cluster --name $CLUSTER_NAME
fi

# Select the config file to be used for this cluster (the one just created by kind)
kubectl config use-context kind-$CLUSTER_NAME
kind get kubeconfig --name "$CLUSTER_NAME" > "$HOME/.kube/$CLUSTER_NAME"
kubectl cluster-info --context kind-$CLUSTER_NAME

echo "Kind cluster successfully created"