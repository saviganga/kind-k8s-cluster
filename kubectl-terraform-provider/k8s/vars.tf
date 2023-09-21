variable "K8S_DEPLOYMENT_FILE_PATH" {
  type    = string
  default = "k8s/deployment.yml"
}

variable "K8S_CONFIGMAP_FILE_PATH" {
  type    = string
  default = "k8s/configmap.yml"
}

variable "K8S_SERVICE_FILE_PATH" {
  type    = string
  default = "k8s/service.yml"
}

variable "CONFIG_FILE_PATH" {
  type    = string
  default = "./config"
}