resource "kubernetes_service" "nginxdemos" {
  metadata {
    name = "terraform"
  }
  spec {
    selector = {
      test = "nginxdemos"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
