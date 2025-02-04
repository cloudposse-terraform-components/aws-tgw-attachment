# Create a TGW attachment from this account's VPC to the TGW Hub
module "standard_vpc_attachment" {
  source  = "cloudposse/transit-gateway/aws"
  version = "0.11.0"

  existing_transit_gateway_id             = var.transit_gateway_id
  existing_transit_gateway_route_table_id = var.transit_gateway_route_table_id

  route_keys_enabled                                             = false
  create_transit_gateway                                         = false
  create_transit_gateway_route_table                             = false
  create_transit_gateway_vpc_attachment                          = true
  create_transit_gateway_route_table_association_and_propagation = false

  config = {
    "this" = {
      vpc_id                            = module.vpc.outputs.vpc_id
      subnet_ids                        = module.vpc.outputs.private_subnet_ids
      route_to                          = []
      route_to_cidr_blocks              = []
      static_routes                     = []
      subnet_route_table_ids            = []
      transit_gateway_vpc_attachment_id = null
      vpc_cidr                          = null
    }
  }

  context = module.this.context
}

locals {
  # Combine external associations with local VPC attachment if enabled
  associations = var.create_transit_gateway_route_table_association ? concat([
    {
      attachment_id  = module.standard_vpc_attachment.transit_gateway_vpc_attachment_ids["this"]
      route_table_id = var.transit_gateway_route_table_id
    }
  ], var.additional_associations) : var.additional_associations
}

# We need to create the association for each of the connected SDLC accounts and for this account itself
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = module.this.enabled ? {
    for assoc in local.associations : assoc.attachment_id => assoc
  } : {}

  transit_gateway_attachment_id  = each.key
  transit_gateway_route_table_id = each.value.route_table_id
}
