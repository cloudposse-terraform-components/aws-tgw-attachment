module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = var.vpc_component_name

  # You can pass the VPC and private subnet IDs directly as inputs to the component to bypass the remote state lookup.
  # Use this with Atmos functions to dynamically set the VPC and private subnet IDs with custom logic.
  bypass = var.vpc_id != null
  defaults = {
    vpc_id             = var.vpc_id
    private_subnet_ids = var.private_subnet_ids
  }

  context = module.this.context
}
