# nodejs-kind-k8s-cluster-with-terraform

- SUMMARY

This repository deploys a simple Hello World express node.js application to a local kinD kubernetes cluster using the kubectl terraform provider

- DIRECTORY EXPLANATION

1. setup_cluster: this folder contains bash sripts to install the dependencies needed for the environment, and provison the kinD kubernetes cluster
    - install-kind.sh: this script checks whether kinD is installed on the system and installs it if not present
    - create-kind-cluster.sh: this script checks for the prerequisites needed to run a kinD kubernetes cluster, installs them, and sets up the cluster.
    It also saves the kubeconfig configurations for the cluster to file for later use

2. hello-world-node-express: this folder contains the express node.js Hello World application

3. kubectl-terraform-provider: this folder contains the terraform deployment of the node.js application to the kinD kubernetes cluster
It also contains the kubernetes configuration files to deploy the application to the cluster
    - k8s: this folder contains the kubernetes configuration files to deploy the node.js application to the kinD kubernetes cluster
        - configmap.yml: contains the environment variables for the kubernetes cluster
        - deployment configuration file for the node.js application
        - service.yml: service configuration file for the kubernetes cluser - used for external access to the deployed container

    - kubernetes.tf: terraform config file to deploy the kubernetes cluster

4. Dockerfile: dockerfile used to build image
5. docker-compose.yml: docker-compose file use for local testing of container environment 

- BONUS
1. run_deployment.sh: this script automates the process needed to setup the environment

- USAGE
1. clone the repository
2. navigate to the root directory of the repository
3. run ./run_deployment.sh - (might need to use sudo)

