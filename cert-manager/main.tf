terraform {
  required_version = ">= 1.1.0"
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    local = {}
    null  = {}
  }
}

provider "kubernetes" {
  host = var.host
  #token = var.ibmcloud_api_key
  client_certificate = base64decode(var.client_certificate)
  client_key         = base64decode(var.client_key)
  #cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.ibmcloud_region
}

resource "kubernetes_namespace" "ibm-cert-manager-namespace" {
  metadata {
    name = var.cert_manager_namespace
  }
}

resource "kubernetes_manifest" "ibm-cert-manager-operator-group" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha2"
    "kind"       = "OperatorGroup"
    "metadata" = {
      "name"      = "cert-manager-operatorgroup"
      "namespace" = var.cert_manager_namespace
    }
  }
}

resource "kubernetes_manifest" "ibm-cert-manager-subscription" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "Subscription"
    "metadata" = {
      "name"      = "ibm-cert-manager-operator"
      "namespace" = var.cert_manager_namespace
    }
    "spec" = {
      "channel"             = var.subscription_channel
      "installPlanApproval" = "Automatic"
      "name"                = "ibm-cert-manager-operator"
      "source"              = "ibm-cert-manager-catalog"
      "sourceNamespace"     = "openshift-marketplace"
    }
  }
  wait {
    fields = {
      "status.catalogHealth[0].healthy" = "true"
    }
  }
}

resource "kubernetes_manifest" "ibm-cert-manager-catalog-source" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "CatalogSource"
    "metadata" = {
      "name"      = "ibm-cert-manager-catalog"
      "namespace" = "openshift-marketplace"
    }
    "spec" = {
      "displayName" = "ibm-cert-manager-4.2.3"
      "publisher"   = "IBM"
      "sourceType"  = "grpc"
      "image"       = var.catalog_source_image
      "updateStrategy" = {
        "registryPoll" = {
          "interval" = "45m"
        }
      }
    }
  }
  wait {
    fields = {
      "status.connectionState.lastObservedState" = "READY"
    }
  }
}