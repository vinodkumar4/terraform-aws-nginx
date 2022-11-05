locals {
  availability_zone_count = var.availability_zone_count != 0 ? var.availability_zone_count : length(data.aws_availability_zones.all.names)

  tags = {
    "managed_by" = "terraform",
    "service"    = "networking"
  }

  private_subnet_tags = merge({ "subnet" = "private" }, local.tags)
  public_subnet_tags  = merge({ "subnet" = "public" }, local.tags)
  cidr_block_newbits  = 4 // for cidr block /16 would result in /20
}

variable "name" {
  description = "VPC name"
  default     = "vpc"
}

variable "cidr_block" {
  description = "VPC cidr block"
}

variable "availability_zone_count" {
  description = "How many AZ should the subnets be created in"
  default     = 0
}

variable "map_public_ip_on_launch" {
  description = "Give hosts in the public subnets public IP addresses as default"
  default     = true
}
