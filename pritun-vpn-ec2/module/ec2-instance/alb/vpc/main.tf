resource "aws_vpc" "main" {

  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "pubsubnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-subnet1-cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "${var.vpc_name}-public-subnet1a"
  }
}

resource "aws_subnet" "pubsubnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-subnet2-cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "${var.vpc_name}-public-subnet1b"
  }
}

resource "aws_subnet" "privatesubnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private-subnet1-cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "${var.vpc_name}-private-subnet1a"
  }
}

resource "aws_subnet" "privatesubnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private-subnet2-cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "${var.vpc_name}-private-subnet1b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.igw-name
  }
}

resource "aws_route_table" "prodinfra-public-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" : var.public-rt-name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" : var.private-rt-name
  }
}

resource "aws_route_table_association" "prod-public-subnet-1" {
  subnet_id      = aws_subnet.pubsubnet-1.id
  route_table_id = aws_route_table.prodinfra-public-RT.id
}

resource "aws_route_table_association" "prod-public-subnet-2" {
  subnet_id      = aws_subnet.pubsubnet-2.id
  route_table_id = aws_route_table.prodinfra-public-RT.id
}

resource "aws_route_table_association" "prod-private-subnet-1" {
  subnet_id      = aws_subnet.privatesubnet-1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "prod-private-subnet-2" {
  subnet_id      = aws_subnet.privatesubnet-2.id
  route_table_id = aws_route_table.private.id
}
