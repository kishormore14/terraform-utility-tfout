terraform {
  required_version = ">= 1.0.0"
}

# Example simulated Route 53 resources
locals {
  domain_name  = "example.com"
  name_servers = ["ns-101.awsdns-12.com", "ns-202.awsdns-25.net", "ns-303.awsdns-37.org"]
}

# Print Route 53 formatted banner via Terraform module
module "route53_banner" {
  source = "../../"

  title   = "ROUTE53 HOSTED ZONE CREATED"
  status  = "success"
  message = "DNS zone deployed and name servers assigned."

  details = {
    "Domain Name"  = local.domain_name
    "Name Servers" = join(", ", local.name_servers)
  }

  items = [
    "DNSSEC validation configured",
    "Health check attached"
  ]
}
