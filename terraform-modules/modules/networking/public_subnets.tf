# Configures public subnets.
#
# Creates the public subnets, route table with a route to the internet gateawy and NAT gateways in each
# subnet to allow hosts in the private subnets to reach the internet.

resource "aws_subnet" "public" {
  count = local.availability_zone_count

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.all.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, local.cidr_block_newbits, count.index + 3)

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = format("%s_%s_public", var.name, data.aws_availability_zones.all.names[count.index])
    },
    local.public_subnet_tags
  )
}


# Add route table to public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = format("%s_route_table", var.name)
    },
    local.tags
  )
}

resource "aws_route_table_association" "public" {
  count          = local.availability_zone_count
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}


# Add route to the internet gateway allowing internet access
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = format("%s_ig", var.name)
    },
    local.tags
  )
}

resource "aws_route" "public_to_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}


# Add NAT Gateways in public subnets allowing hosts in the private subnets to access the internet.
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.gateway]
  count      = local.availability_zone_count
  vpc        = true

  tags = merge(
    {
      "Name" = format("%s_eip_%d", var.name, count.index)
    },
    local.tags
  )
}

resource "aws_nat_gateway" "nat" {
  count         = local.availability_zone_count
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat_eip[count.index].id


  tags = merge(
    {
      "Name" = format("%s_nat_%d", var.name, count.index)
    },
    local.tags
  )
}

