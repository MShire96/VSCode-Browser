##########################
# Network Infrastructure #
##########################

resource "aws_vpc" "vscoder" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true
}

#########################################################
# Internet Gateway needed for inbound access to the ALB #
#########################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vscoder.id
  
}

#########################################################
# NAT Gateway needed for inbound access to the ALB #
#########################################################

resource "aws_eip" "nat" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "vscoder" {
  allocation_id = aws_eip.nat.id
  subnet_id         = aws_subnet.public[0].id
  
  depends_on = [aws_internet_gateway.igw]
}


#########################################################
# Public subnets for load balancer public access #
#########################################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vscoder.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


############
# Subnets #
############

resource "aws_subnet" "public" {
  count = 2

  vpc_id            = aws_vpc.vscoder.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = var.azs[count.index]
}



#########################################################
# Private subnets for load balancer public access #
#########################################################


resource "aws_subnet" "private" {
  count = 2

  vpc_id            = aws_vpc.vscoder.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.azs[count.index]
}

resource "aws_route_table" "private" {
  count = 2

  vpc_id = aws_vpc.vscoder.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vscoder.id
  }
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
