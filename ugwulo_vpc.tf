# Create Ugwulo VPC
resource "aws_vpc" "ugwulo_vpc" {
  cidr_block       = var.ugwulo_vpc_cidr
  instance_tenancy = var.instance_tenancy

  tags = {
    "Name" = "Ugwulo VPC"
  }
}

# use data source to get all available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}


# Create 3 public subnets
resource "aws_subnet" "public_subnets" {

  count = var.ugwulo_vpc_cidr == "10.0.0.0/16" ? 3 : 0

  vpc_id            = aws_vpc.ugwulo_vpc.id
  cidr_block        = element(cidrsubnets(var.ugwulo_vpc_cidr, 8, 4, 4), count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Public Subnet-${count.index + 1}"
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ugwulo_vpc.id

  tags = {
    Name = "Internet-Gateway"
  }
}

# Create a public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ugwulo_vpc.id

  tags = {
    "Name" = "Public-RouteTable"
  }
}

# Create a Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.igw_cidr
  gateway_id             = aws_internet_gateway.igw.id
}

# Create a Public Route Table association using subnets
resource "aws_route_table_association" "public_rt_association" {
  count          = length(aws_subnet.public_subnets) == 3 ? 3 : 0
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
}