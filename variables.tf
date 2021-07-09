variable "namespace" {
  type        = string
  default     = "default"
  description = "namespace"
}

variable "create_namespace" {
  type        = bool
  description = "create or not namespace"
  default     = true
}

variable "crt" {
  type        = string
  description = "docker registry tls.crt"
  sensitive   = true
}

variable "key" {
  type        = string
  description = "docker registry tls.key"
  sensitive   = true
}

variable "auth" {
  type        = string
  description = "docker registry auth"
  sensitive   = true
}

variable "image" {
  type        = string
  default     = "registry:2.6.2"
  description = "docker registry image"
}

variable "address" {
  type        = string
  default     = "0.0.0.0"
  description = "docker registry address"
}

variable "port" {
  type        = number
  default     = 1000
  description = "docker registry port"
}

variable "storage" {
  type        = string
  default     = "dir"
  description = "storage type: dir, pvc"
}

variable "pvc" {
  type        = string
  description = "pvc name"
}

