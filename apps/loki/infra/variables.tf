variable "project" {
  description = "Directory of the project: the settings of the app are under apps.loki of its stack.yaml. damstack sets it."
  type        = string
}

variable "state_passphrase" {
  description = "Passphrase the state and plans are encrypted with; the platform gives it."
  type        = string
  sensitive   = true
}
