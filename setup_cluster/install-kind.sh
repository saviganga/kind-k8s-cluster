#!/bin/bash

# check the architecture of the system 
if [ $(uname -m) = "x86_64" ] then
    
    # check if kind is already installed
    if [! command -v kind &>/dev/null] then
        curl -Lo ./kind 'https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64' 
    else
        echo "kind is already installed"
    fi
else
    if [$(uname -m) = "aarch64"] then

        if [! command -v kind &>/dev/null] then
            curl -Lo ./kind 'https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64'
        else
            echo "kind is already installed"
        fi
    fi
fi

# make the downloaded package executable
chmod +x ./kind

# move the downloaded package to an application directory
sudo mv ./kind /bin/kind

echo "Successfully installed kind"


