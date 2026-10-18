locals {
  stack = yamldecode(file("${var.project}/stack.yaml"))
}

module "stack" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-hashistack.git?ref=v1.0.0"

  address           = cidrhost(local.stack.network.cidr, 1)
  ca_pem            = file("${var.project}/ca.pem")
  ca_key_pem        = var.stack_ca_key
  traefik_dashboard = try(local.stack.traefik.dashboard, false)
}

removed {
  from = tls_private_key.internal

  lifecycle {
    destroy = false
  }
}

removed {
  from = tls_cert_request.internal

  lifecycle {
    destroy = false
  }
}

removed {
  from = tls_locally_signed_cert.internal

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.mail

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dns

  lifecycle {
    destroy = false
  }
}
