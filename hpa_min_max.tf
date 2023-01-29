provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_horizontal_pod_autoscaler" "my_hpa" {
  metadata {
    name      = "myhpa"
    namespace = "dev-zk"
  }
  spec {
    max_replicas = 5
    min_replicas = 3

    target_cpu_utilization_percentage = 80

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "mydeploy"
    }
  }
}
