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

echo " $ARCH "
# Check if kind is already installed
if ! command -v kind &>/dev/null; then
    # Download the appropriate kind binary based on architecture
    KIND_VERSION="v0.20.0"
    KIND_URL="https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-$ARCH"

    echo $KIND_URL
    
    # Download kind
    curl -Lo ./kind $KIND_URL

    # Make the downloaded package executable
    chmod +x ./kind

    # Move the downloaded package to an application directory
    sudo mv ./kind /usr/local/bin/kind

    echo "Successfully installed kind"
else
    echo "kind is already installed"
fi


# Check if the cluster already exists
# if kind get clusters | grep -q "$CLUSTER_NAME"; then
#   echo "Cluster $CLUSTER_NAME already exists. Deleting it..."
#   kind delete cluster --name "$CLUSTER_NAME"
# fi