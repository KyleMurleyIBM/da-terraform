variable "licensing_subscription_channel" {
  type        = string
  default     = "v4.1"
  description = "Channel of the licensing service subscription"
}

variable "licensing_catalog_source_image" {
  type        = string
  default     = "icr.io/cpopen/ibm-licensing-catalog"
  description = "Source image for the catalog source"
}

variable "licensing_namespace" {
  type        = string
  default     = "ibm-licensing"
  description = "Name for the licensing namespace"
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
