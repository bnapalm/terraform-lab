variable "cidr" {
  description = "CIDR of the VPC"
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "How many public and private subnets to create"
  default = 2
}

variable "private_subnet_offset" {
  description = "Number of subnets to offset for private subnets from public subnets."
  default = 100
}


variable "name" {
    description = "Name of the VPC"
    default = "my-vpc"
}