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
  host               = var.host
  client_certificate = base64decode(var.client_certificate)
  client_key         = base64decode(var.client_key)
  # cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.ibmcloud_region
}

resource "kubernetes_namespace" "ibm-licensing-service-namespace" {
  metadata {
    name = var.licensing_namespace
  }
}

resource "kubernetes_manifest" "ibm-licensing-service-operator-group" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind"       = "OperatorGroup"
    "metadata" = {
      "name"      = "licensing-operatorgroup"
      "namespace" = var.licensing_namespace
    }
    "spec" = {
      "targetNamespaces" = [
        var.licensing_namespace,
      ]
    }
  }
}

resource "kubernetes_manifest" "ibm-licensing-service-subscription" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "Subscription"
    "metadata" = {
      "name"      = "ibm-licensing-operator-app"
      "namespace" = var.licensing_namespace
    }
    "spec" = {
      "channel"             = var.licensing_subscription_channel
      "installPlanApproval" = "Automatic"
      "name"                = "ibm-licensing-operator-app"
      "source"              = "ibm-licensing-catalog"
      "sourceNamespace"     = "openshift-marketplace"
    }
  }
  wait {
    fields = {
      "status.catalogHealth[0].healthy" = "true"
    }
  }
}

resource "kubernetes_manifest" "ibm-licensing-service-catalog-source" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "CatalogSource"
    "metadata" = {
      "name"      = "ibm-licensing-catalog"
      "namespace" = "openshift-marketplace"
    }
    "spec" = {
      "displayName" = "IBM License Service Catalog"
      "publisher"   = "IBM"
      "sourceType"  = "grpc"
      "image"       = var.licensing_catalog_source_image
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