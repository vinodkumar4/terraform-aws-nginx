# Configures private subnets.
#
# Creates the private subnets, route table and a route to the NAT gateway in the public subnet to allow internet access.

resource "aws_subnet" "private" {
  count = local.availability_zone_count

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.all.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, local.cidr_block_newbits, count.index)

  tags = merge(
    {
      "Name" = format("%s_%s_private", var.name, data.aws_availability_zones.all.names[count.index])
    },
    local.private_subnet_tags
  )
}

resource "aws_route_table" "private" {
  count  = local.availability_zone_count
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = format("%s_route_table_%d", var.name, count.index)
    },
    local.tags
  )
}

resource "aws_route_table_association" "private" {
  count          = local.availability_zone_count
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_route" "private_to_nat" {
  count = local.availability_zone_count

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}
