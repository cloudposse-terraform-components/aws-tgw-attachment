output "transit_gateway_vpc_attachment_id" {
  value       = module.standard_vpc_attachment.transit_gateway_vpc_attachment_ids["this"]
  description = "ID of the Transit Gateway VPC Attachment"
}
