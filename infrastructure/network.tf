# VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "${var.base_cidr_block}/16"

  enable_dns_support = "true"
  enable_dns_hostnames  = "true"

  tags = {
    Name = "${var.project_name}-${var.stage}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.stage}-igw"
  }
}

# Public routing table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-${var.stage}-public-route"
  }
}

# Subnets
resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc.id

    cidr_block = "10.0.1.0/24"
    availability_zone =  var.availability_zones[0]

    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-${var.stage}-public-subnet-1"
    }
}

resource "aws_route_table_association" "public-subnet-1-public-route-association" {
    subnet_id = aws_subnet.public-subnet-1.id
    route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.vpc.id

    cidr_block = "10.0.2.0/24"
    availability_zone =  var.availability_zones[1]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-${var.stage}-public-subnet-2"
    }
}

resource "aws_route_table_association" "public-subnet-2-public-route-association" {
    subnet_id = aws_subnet.public-subnet-2.id
    route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "public-subnet-3" {
    vpc_id = aws_vpc.vpc.id

    cidr_block = "10.0.3.0/24"
    availability_zone =  var.availability_zones[2]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-${var.stage}-public-subnet-3"
    }
}

resource "aws_route_table_association" "public-subnet-3-public-route-association" {
    subnet_id = aws_subnet.public-subnet-3.id
    route_table_id = aws_route_table.public-route-table.id
}
