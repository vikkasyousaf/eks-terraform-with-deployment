resource "kubernetes_deployment" "nginxdemos" {
  metadata {
    name = "terraform"
    labels = {
      test = "nginxdemos"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "nginxdemos"
      }
    }

    template {
      metadata {
        labels = {
          test = "nginxdemos"
        }
      }

      spec {
        container {
          image = "nginxdemos/hello:0.3"
          name  = "nginxdemos"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
