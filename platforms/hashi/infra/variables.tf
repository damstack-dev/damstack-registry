variable "project" {
  description = "Directory of the project: stack.yaml and ca.pem are read from it. damstack sets it."
  type        = string
}

variable "state_passphrase" {
  description = "Passphrase the state and plans are encrypted with; kept in vault.yml of the project."
  type        = string
  sensitive   = true
}

variable "stack_ca_key" {
  description = "PEM private key of the project's CA; it signs the certificate of the admin pages, for *.service.consul. Kept in vault.yml of the project."
  type        = string
  sensitive   = true
}
