variable "cert_manager_subscription_channel" {
  type        = string
  default     = "v4.2"
  description = "Channel of the licensing service subscription"
}

variable "cert_manager_catalog_source_image" {
  type        = string
  default     = "icr.io/cpopen/ibm-cert-manager-operator-catalog"
  description = "Source image for the catalog source"
}

variable "cert_manager_namespace" {
  type        = string
  default     = "ibm-cert-manager"
  description = "Name for the cert manager namespace"
}
####################
# Cluster configuration
####################
variable "host" {
  type    = string
  default = "https://c117-e.us-south.containers.cloud.ibm.com:31085"
}

variable "client_certificate" {
  type    = string
  default = "LS0tincrediblylongclientcertificateLS0tCg=="
}

variable "client_key" {
  type    = string
  default = "LS0tincrediblylongclientkeyLS0tLQo="
}

variable "cluster_ca_certificate" {
  type    = string
  default = "n/a"
}

variable "ibmcloud_api_key" {
  description = "IBM Cloud API key"
}

variable "ibmcloud_region" {
  description = "IBM Cloud region where all resources will be deployed"
  default     = "us-south"
}

variable "cluster_id" {
  type        = string
  description = "ID of the cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "link_kube_config" {
  description = "configure kube config to access cluster"
  default     = false
}

variable "resource_group_name" {
  description = "Name of the IBM Cloud resource group in which resources should be created"
  default     = "Default"
}

variable "cluster_node_flavor" {
  default = "bx2.8x32"
}

variable "cluster_kube_version" {
  default = "4.14.22_openshift"
}

variable "worker_nodes_per_zone" {
  description = "Number of initial worker nodes per zone for the ROKS cluster. Select at least 3 for single zone and 2 for multizone clusters."
  default     = 3
}

variable "no_of_zones" {
  description = "Number of Zones for the ROKS cluster"
  default     = 1
}

variable "force_delete_storage" {
  default = true
}

variable "entitlement" {
  default = "cloud_pak"
}

variable "spending_env" {
  description = "purpose of resource"
  default     = "test"
}