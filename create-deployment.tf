provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment_v1" "my_deploymentttt" {
  metadata {
    name      = "terraform-example"
    namespace = "dev-zk"
    labels = {
      test = "myapp"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "myapp"
      }
    }

    template {
      metadata {
        labels = {
          test = "myapp"
        }
      }

      spec {
        container {
          image = "adilreza043/html-server-image:v1"
          name  = "html-server"

          resources {
            limits = {
              cpu    = "60m"
              memory = "70Mi"
            }
            requests = {
              cpu    = "30m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 10
          }
        }
      }
    }
  }
}
