resource "aws_vpc" "main" {

  cidr_block           = "14.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {

    Name = "mysql-setup-Infra-VPC"

  }

}

resource "aws_subnet" "pubsubnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "14.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "mysql-setup-public-subnet-1a"
  }
}

resource "aws_subnet" "pubsubnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "14.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "mysql-setup-public-subnet-1b"
  }
}

resource "aws_subnet" "privatesubnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "14.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "mysql-setup-private-subnet-1a"
  }
}

resource "aws_subnet" "privatesubnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "14.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "mysql-setup-private-subnet-1b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "mysql-setup-vpc-igw-mumbai"
  }
}

resource "aws_route_table" "mysql-setup-public-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" : "mysql-setup-public-RT"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    "Name" : "mysql-setup-private-RT"
  }
}



resource "aws_eip" "nat_gw_eip" {
  domain = "vpc"
  tags = {
    "Name" : "mysql-setup-EIP"
  }
}



resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.pubsubnet-1.id
  tags = {
    Name = "mysql-setup-NAT-GW"
  }
}

resource "aws_route_table_association" "prod-public-subnet-1" {
  subnet_id      = aws_subnet.pubsubnet-1.id
  route_table_id = aws_route_table.mysql-setup-public-RT.id
}

resource "aws_route_table_association" "prod-public-subnet-2" {
  subnet_id      = aws_subnet.pubsubnet-2.id
  route_table_id = aws_route_table.mysql-setup-public-RT.id
}

resource "aws_route_table_association" "prod-private-subnet-1" {
  subnet_id      = aws_subnet.privatesubnet-1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "prod-private-subnet-2" {
  subnet_id      = aws_subnet.privatesubnet-2.id
  route_table_id = aws_route_table.private.id
}
