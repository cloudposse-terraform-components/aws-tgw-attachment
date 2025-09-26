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

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to attach to"
  default     = null
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs of the private subnets to attach to. Required if `vpc_id` is defined."
  default     = []
}
