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

variable "vpc_component_name" {
  type        = string
  description = "The name of the vpc component"
  default     = "vpc"
}
