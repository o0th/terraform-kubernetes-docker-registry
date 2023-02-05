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

Certificate

```bash
openssl genrsa -out tls.key 4096
openssl req -new -x509 -text -key tls.key -out tls.cert
```

Htpasswd file

```bash
htpasswd -c auth <username>
```

Terraform

```bash
terraform init
terraform plan
terraform apply
```

