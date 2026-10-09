terraform {
  required_version = ">= 1.0.0"
}

# Use the tfout banner module
module "banner" {
  source = "../../"

  title   = "INFRASTRUCTURE DEPLOYED SUCCESSFULLY"
  status  = "success"
  message = "Core network VPC and security groups configured."

  details = {
    "VPC ID"      = "vpc-0a1b2c3d4e5f"
    "Environment" = "production"
    "Region"      = "us-east-1"
  }

  items = [
    "Public subnets ready",
    "NAT gateways online"
  ]

  theme  = "default"
  border = "single"
}
