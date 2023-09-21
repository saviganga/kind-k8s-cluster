terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

provider "kubectl" {
  config_path    = "~/.kube/config"
}

variable "K8S_DEPLOYMENT_FILE_PATH" {
  description = "Path to the configuration file"
  type        = string
  default     = "k8s/deployment.yml" # Provide a default value or remove this line if not needed
}

variable "K8S_CONFIGMAP_FILE_PATH" {
  description = "Path to the configuration file"
  type        = string
  default     = "k8s/configmap.yml" # Provide a default value or remove this line if not needed
}

variable "K8S_SERVICE_FILE_PATH" {
  description = "Path to the configuration file"
  type        = string
  default     = "k8s/service.yml" # Provide a default value or remove this line if not needed
}

variable "CONFIG_FILE_PATH" {
  description = "Path to the configuration file"
  type        = string
  default     = "/config" # Provide a default value or remove this line if not needed
}

resource "null_resource" "config-map" {
    triggers = {
        kubeconfig = filemd5("${path.module}${var.CONFIG_FILE_PATH}")
        configmap = filemd5("${path.module}${var.CONFIG_FILE_PATH}")
    }
    provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/${var.K8S_CONFIGMAP_FILE_PATH}"
  }
}

resource "null_resource" "deployment" {
    triggers = {
        kubeconfig = filemd5("${path.module}${var.CONFIG_FILE_PATH}")
        deployment = filemd5("${path.module}/${var.K8S_DEPLOYMENT_FILE_PATH}")
    }
    provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/${var.K8S_DEPLOYMENT_FILE_PATH}"
  }
}

resource "null_resource" "service" {
    triggers = {
        kubeconfig = filemd5("${path.module}${var.CONFIG_FILE_PATH}")
        deployment = filemd5("${path.module}/${var.K8S_SERVICE_FILE_PATH}")
    }
    provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/${var.K8S_SERVICE_FILE_PATH}"
  }
}


