<br /><br />
<div align="center">
  <img src="https://img.shields.io/badge/module-terraform--kubernetes--docker--registry-blue?style=for-the-badge&logo=terraform" />
  <img src="https://img.shields.io/github/v/tag/o0th/terraform-kubernetes-docker-registry?style=for-the-badge" />
</div>
<br /><br />


## Description

Terraform module which deploys a docker-registry on kubernetes

## Requirements

* Terraform 0.13+
* Kubernetes cluster

## Configuration

Basic

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

  create_namespace = false

  crt = file("tls.cert")
  key = file("tls.key")

  auth = file("auth")

  storage = "pvc"
  pvc     = kubernetes_persistent_volume_claim.docker.metadata[0].name
}
```

Generate htpasswd file

```bash
htpasswd -B auth <username>
```
