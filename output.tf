output "service_name" {
  value = kubernetes_service.this.metadata[0].name
}

output "service_port" {
  value = var.port
}

output "secret_name" {
  value = kubernetes_secret.cert.metadata[0].name
}
