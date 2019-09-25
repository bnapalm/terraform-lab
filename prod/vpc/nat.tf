# Elastic IPs for NAT GWs
resource "aws_eip" "nat" {
  count = var.SUBNET_COUNT
  vpc   = true
}

# NAT Gateways
resource "aws_nat_gateway" "nat-gw" {
  count         = var.SUBNET_COUNT
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.main-public[count.index].id

  tags = {
    Name = "nat-gw-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main-igw]
}

# Route Tables for NAT
resource "aws_route_table" "main-private" {
  count  = var.SUBNET_COUNT
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }

  tags = {
    Name = "main-private-${count.index + 1}"
  }
}

# Route Associations Private
resource "aws_route_table_association" "main-private-a" {
  count          = var.SUBNET_COUNT
  subnet_id      = aws_subnet.main-private[count.index].id
  route_table_id = aws_route_table.main-private[count.index].id
}