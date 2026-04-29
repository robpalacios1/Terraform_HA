#1. Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
    environment = var.vpc_environment
  }
}

#2. Create a Internet Gateway
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = var.internet_gateway_name
    environment = var.vpc_environment
  }
}

#3. Create a public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_1_cidr_block
  availability_zone = var.availability_zone_1
  tags = {
    Name = var.public_subnet_1_name
    environment = var.vpc_environment
  }
}

#4. Create a public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_2_cidr_block
  availability_zone = var.availability_zone_2
  tags = {
    Name = var.public_subnet_2_name
    environment = var.vpc_environment
  }
}

#5. Create a private subnet 1 for the application
resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_1_cidr_block
  availability_zone = var.availability_zone_1
  tags = {
    Name = var.private_subnet_1_name
    environment = var.vpc_environment
  }
}

#6. Create a private subnet 2 for the database
resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_2_cidr_block
  availability_zone = var.availability_zone_2
  tags = {
    Name = var.private_subnet_2_name
    environment = var.vpc_environment
  }
}

#7. Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = var.public_route_table_name
    environment = var.vpc_environment
  }
}