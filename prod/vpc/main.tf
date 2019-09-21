data "aws_availability_zones" "all" {} 

resource "null_resource" "public_subnets" {
    count = var.subnet_count

    cidr = cidrsubnet(var.cidr, 8, (count.index + 1))
}

resource "null_resource" "private_subnets" {
    count = var.subnet_count

    cidr = cidrsubnet(var.cidr, 8, (count.index + var.private_subnet_offset + 1))
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = var.name
    cidr = var.cidr

    azs = data.aws_availability_zones.all.zone_ids
    private_subnets = null_resource.private_subnets[*].cidr
    public_subnets = null_resource.public_subnets[*].cidr

    enable_nat_gateway = true

}