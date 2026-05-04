#1. Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name        = var.vpc_name
    environment = var.vpc_environment
  }
}

#2. Create a Internet Gateway
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = var.internet_gateway_name
    environment = var.vpc_environment
  }
}

#3. Create a public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = var.public_subnet_map_public_ip_on_launch
  tags = {
    Name        = var.public_subnet_1_name
    environment = var.vpc_environment
  }
}

#4. Create a public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_2_cidr_block
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = var.public_subnet_map_public_ip_on_launch
  tags = {
    Name        = var.public_subnet_2_name
    environment = var.vpc_environment
  }
}

#5. Create a private subnet 1 for the application
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_1_cidr_block
  availability_zone = var.availability_zone_1
  tags = {
    Name        = var.private_subnet_1_name
    environment = var.vpc_environment
  }
}

#6. Create a private subnet 2 for the database
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_2_cidr_block
  availability_zone = var.availability_zone_2
  tags = {
    Name        = var.private_subnet_2_name
    environment = var.vpc_environment
  }
}

#7. Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = var.public_route_table_name
    environment = var.vpc_environment
  }
}

#8. Create a route table destination CIDR block
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = var.public_route_destination_cidr_block
  gateway_id             = aws_internet_gateway.main_internet_gateway.id
}

#9 Create a route table Association for subnet 1
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

#9 Create a route table Association for subnet 2
resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

#10. Elastic IPs for NAT1
resource "aws_eip" "nat_eip_az1" {
  vpc = true
  tags = {
    Name        = var.nat_eip_az1
    environment = var.vpc_environment
  }
}

#11. Elastic IPs for NAT2
resource "aws_eip" "nat_eip_az2" {
  vpc = true
  tags = {
    Name        = var.nat_eip_az2
    environment = var.vpc_environment
  }
}

#12. NAT Gateway on public subnet 1(AZ1)
resource "aws_nat_gateway" "aws_nat_gateway_az1" {
  allocation_id = aws_eip.nat_eip_az1.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name        = var.nat_gateway_az1
    environment = var.vpc_environment
  }
  depends_on = [aws_internet_gateway.main_internet_gateway]
}

#13. NAT Gateway on public subnet 2(AZ2)
resource "aws_nat_gateway" "aws_nat_gateway_az2" {
  allocation_id = aws_eip.nat_eip_az2.id
  subnet_id     = aws_subnet.public_subnet_2.id
  tags = {
    Name        = var.nat_gateway_az2
    environment = var.vpc_environment
  }
  depends_on = [aws_internet_gateway.main_internet_gateway]
}

#14. private Route Table AZ1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = var.private_route_table_az1_name
    environment = var.vpc_environment
  }
}

#15. private Route Table AZ2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = var.private_route_table_az2_name
    environment = var.vpc_environment
  }
}

#16. Default Route Private AZ1 -> NAT AZ1
resource "aws_route" "private_default_route_az1" {
  route_table_id         = aws_route_table.private_route_table_az1.id
  destination_cidr_block = var.public_route_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.aws_nat_gateway_az1.id
}

#17. Default Route Private AZ2 -> NAT AZ2
resource "aws_route" "private_default_route_az2" {
  route_table_id         = aws_route_table.private_route_table_az2.id
  destination_cidr_block = var.public_route_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.aws_nat_gateway_az2.id
}

#18. Association of Privates Subnet 1
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_az1.id
}

#19. Association of Privates Subnet 2
resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_az2.id
}

resource "aws_security_group" "public_instance_sg" {
  name = "public-instance-sg"
  description = "Security group for public instances"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.public_subnet_1_cidr_block]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.public_route_destination_cidr_block]
  }
  tags = {
    Name        = var.public_instance_sg_name
    environment = var.vpc_environment
  }
}

resource "aws_security_group" "private_instance_sg" {
  name = "private-instance-sg"
  description = "Security group for private instances"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.public_route_destination_cidr_block]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.public_route_destination_cidr_block]
  }
  tags = {
    Name        = var.private_instance_sg_name
    environment = var.vpc_environment
  }
}

resource "aws_instance" "public_instance_1" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]
  tags = {
    Name        = var.public_instance_1_name
    environment = var.vpc_environment
  }
}

resource "aws_instance" "public_instance_2" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]
  tags = {
    Name        = var.public_instance_2_name
    environment = var.vpc_environment
  }
}

resource "aws_instance" "private_instance_1" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
  tags = {
    Name        = var.private_instance_1_name
    environment = var.vpc_environment
  }
}

resource "aws_instance" "private_instance_2" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.private_subnet_2.id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
  tags = {
    Name        = var.private_instance_2_name
    environment = var.vpc_environment
  }
}