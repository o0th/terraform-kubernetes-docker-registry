provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "docker-registry" {
  source = "../"

  namespace = "docker"

  crt = file("${path.module}/tls.crt")
  key = file("${path.module}/tls.key")

  auth = file("${path.module}/auth")
}
