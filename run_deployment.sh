#!/bin/bash

# this script automatically deploys the environment described in the assessment
echo "setting up environment..."
sleep 2
# 1. write a bash script that deploys a kind cluster locally, save the kubeconfig file to be used later
echo "setting up environment dependencies..."
sleep 2
./setup_cluster/install-kind.sh
./setup_cluster/create-kind-cluster.sh

#2. use 'kubectl' terraform provider to deploy the dockerized node.js express application to the kubernetes cluster
echo "deploying environment"
sleep 2
./kubectl-terraform-provider terraform apply