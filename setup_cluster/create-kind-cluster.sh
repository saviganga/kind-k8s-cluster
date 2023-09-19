#!/bin/bash

# define the cluster name
CLUSTER_NAME = 'ignitedotdev'

echo "Creating kind cluster..."

# install kind
kind create cluster --name $CLUSTER_NAME

# select the config file to be used for this cluster - (the one just created by kind)
kubectl config use-context $CLUSTER_NAME
kubectl cluster-info --context kind-$CLUSTER_NAME

echo "Kind cluster successfully created"