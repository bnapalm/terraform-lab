# Main VPC
resource "aws_vpc" "main" {
  cidr_block                       = var.VPC_CIDR
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  enable_classiclink               = false
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name = "main"
  }
}

# Get available AZs
data "aws_availability_zones" "zones" {}

# Public Subnets
resource "aws_subnet" "main-public" {
  count                   = var.SUBNET_COUNT
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, (count.index + 1))
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "main-public-${count.index + 1}"
    Tier = "public"
  }
}


# Private Subnets
resource "aws_subnet" "main-private" {
  count                   = var.SUBNET_COUNT
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, (var.SUBNET_COUNT + count.index + 1))
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "main-private-${count.index + 1}"
    Tier = "private"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Route Tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "main-public-rt"
  }
}

# Route Associations Public
resource "aws_route_table_association" "main-public-a" {
  count          = length(aws_subnet.main-public)
  subnet_id      = aws_subnet.main-public[count.index].id
  route_table_id = aws_route_table.main-public.id
}