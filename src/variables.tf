variable "region" {
  type        = string
  description = "AWS Region"
}

variable "transit_gateway_id" {
  type        = string
  description = "ID of the Transit Gateway to attach to"
}

variable "transit_gateway_route_table_id" {
  type        = string
  description = "ID of the Transit Gateway Route Table"
}

variable "create_transit_gateway_route_table_association" {
  type        = bool
  description = "Whether to create the Transit Gateway Route Table Association"
  default     = true
}

variable "additional_associations" {
  type = list(object({
    attachment_id  = string
    route_table_id = string
  }))
  description = "List of TGW attachments to associate with route tables"
  default     = []
}
