# Create a TGW attachment from this account's VPC to the TGW Hub
module "standard_vpc_attachment" {
  source  = "cloudposse/transit-gateway/aws"
  version = "0.12.0"

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
  # Create associations list with static keys to avoid for_each issues with computed values
  # Each association needs a static key for the for_each map, while attachment_id can be computed
  associations = var.create_transit_gateway_route_table_association ? concat([
    {
      key            = "this" # Static key for local VPC attachment
      attachment_id  = module.standard_vpc_attachment.transit_gateway_vpc_attachment_ids["this"]
      route_table_id = var.transit_gateway_route_table_id
    }
    ], [
    # Add additional associations with indexed keys to ensure uniqueness
    for i, assoc in var.additional_associations : {
      key            = "additional-${i}"
      attachment_id  = assoc.attachment_id
      route_table_id = assoc.route_table_id
    }
    ]) : [
    # Only additional associations if local association is disabled
    for i, assoc in var.additional_associations : {
      key            = "additional-${i}"
      attachment_id  = assoc.attachment_id
      route_table_id = assoc.route_table_id
    }
  ]
}

# Create TGW route table associations using static keys to avoid computed value issues
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = module.this.enabled ? {
    for assoc in local.associations : assoc.key => assoc # Use static key, not computed attachment_id
  } : {}

  transit_gateway_attachment_id  = each.value.attachment_id # Reference computed value here
  transit_gateway_route_table_id = each.value.route_table_id
}
