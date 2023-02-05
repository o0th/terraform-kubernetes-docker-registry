# terraform-kubernetes-docker-registry

Terraform module which deploys a docker-registry on kubernetes

## Requirements

* Terraform 0.13+
* Kubernetes cluster

## Usage

Configuration

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

