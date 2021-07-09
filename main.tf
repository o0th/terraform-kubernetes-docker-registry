resource "kubernetes_namespace" "this" {
  count = (var.create_namespace == true ? 1 : 0)

  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "cert" {
  metadata {
    name      = "cert"
    namespace = var.namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = base64encode(var.crt)
    "tls.key" = base64encode(var.key)
  }
}

resource "kubernetes_secret" "auth" {
  metadata {
    name      = "auth"
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    "htpasswd" = base64encode(var.auth)
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = "docker-registry"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app" = "docker-registry"
      }
    }

    template {
      metadata {
        labels = {
          "app" = "docker-registry"
        }
      }

      spec {
        container {
          name  = "docker-registry"
          image = var.image

          env {
            name  = "REGISTRY_AUTH"
            value = "htpasswd"
          }

          env {
            name  = "REGISTRY_AUTH_HTPASSWD_REALM"
            value = "realm"
          }

          env {
            name  = "REGISTRY_AUTH_HTPASSWD_PATH"
            value = "/auth/htpasswd"
          }

          env {
            name  = "REGISTRY_HTTP_ADDR"
            value = "${var.address}:${var.port}"
          }

          env {
            name  = "REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY"
            value = "/var/lib/registry"
          }

          env {
            name  = "REGISTRY_HTTP_TLS_CERTIFICATE"
            value = "/certs/tls.crt"
          }

          env {
            name  = "REGISTRY_HTTP_TLS_KEY"
            value = "/certs/tls.key"
          }

          port {
            name           = "https"
            container_port = var.port
          }

          volume_mount {
            name       = "storage"
            mount_path = "/var/lib/registry"
          }

          volume_mount {
            name       = "auth"
            mount_path = "/auth"
          }

          volume_mount {
            name       = "certs"
            mount_path = "/certs"
          }
        }

        dynamic "volume" {
          for_each = (var.storage == "dir" ? [1] : [])
          content {
            name = "storage"
            empty_dir {}
          }
        }

        dynamic "volume" {
          for_each = (var.storage == "pvc" ? [1] : [])
          content {
            name = "storage"
            persistent_volume_claim {
              claim_name = var.pvc
            }
          }
        }

        volume {
          name = "auth"
          secret {
            secret_name = kubernetes_secret.auth.metadata[0].name
          }
        }

        volume {
          name = "certs"
          secret {
            secret_name = kubernetes_secret.cert.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = "docker-registry"
    namespace = var.namespace
    labels = {
      "app" = "docker-registry"
    }
  }

  spec {
    selector = {
      "app" = "docker-registry"
    }

    port {
      name = "https"
      port = var.port
    }
  }
}

