variable "project" {
  description = "Directory of the project: stack.yaml, and in dns/ the records every app leaves there. damstack sets it."
  type        = string
}

variable "state_passphrase" {
  description = "Passphrase the state and plans are encrypted with; the platform gives it."
  type        = string
  sensitive   = true
}
