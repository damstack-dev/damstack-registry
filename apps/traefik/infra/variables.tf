variable "project" {
  description = "Directory of the project: the settings of the app are under apps.traefik of its stack.yaml, and ca.pem is the CA of the platform's Consul. damstack sets it."
  type        = string
}

variable "state_passphrase" {
  description = "Passphrase the state and plans are encrypted with; the platform gives it."
  type        = string
  sensitive   = true
}
