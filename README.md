# terraform-kubernetes-docker-registry

[![Stack](https://skillicons.dev/icons?i=raspberrypi,kubernetes)](https://skillicons.dev)

Terraform module which deploys a docker-registry on kubernetes

## Requirements

* Terraform 0.13+
* Kubernetes cluster

## Usage

Without storage

```terraform
provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "docker-registry" {
  source = "github.com/o0th/terraform-kubernetes-docker-registry"

  namespace = "docker"

  crt = file("${path.module}/tls.crt")
  key = file("${path.module}/tls.key")

  auth = file("${path.module}/auth")
}
```

With storage

```terraform
module "docker" {
  source = "../terraform-kubernetes-docker-registry"

  namespace        = kubernetes_namespace.docker.metadata[0].name
  create_namespace = false

  crt = file("tls.cert")
  key = file("tls.key")

  auth = file("auth")

  storage = "pvc"
  pvc     = kubernetes_persistent_volume_claim.docker.metadata[0].name
}
```

Htpasswd file

```bash
htpasswd -B auth <username>
```

Terraform

```bash
terraform init
terraform plan
terraform apply
```

