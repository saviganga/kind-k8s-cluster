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

# define the cluster name
CLUSTER_NAME='ignitedotdev'

KUBECTL="kubectl"

KUBECTL_LATEST_RELEASE_URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$ARCH/kubectl"
KUBECTL_CHECKSUM_URL="https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "Creating kind cluster..."

# check if kubectl is installed
dpkg -s $KUBECTL &> /dev/null

if [ $? -eq 0 ]; then
    echo "$KUBECTL is installed, moving on ..."
else
    echo "installing $KUBECTL ..."

    # download the latest kubectl release for your architecture
    curl -LO "$KUBECTL_LATEST_RELEASE_URL"

    # install kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

# install kind
kind create cluster --name $CLUSTER_NAME

# select the config file to be used for this cluster - (the one just created by kind)
kubectl config use-context $CLUSTER_NAME
kubectl cluster-info --context kind-$CLUSTER_NAME

echo "Kind cluster successfully created"