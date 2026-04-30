output "vpc_id" {
  description = "ID of the VPC"
  value = aws_vpc.main_vpc.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value = aws_internet_gateway.main_internet_gateway.id
}

output "public_subnet_1_id" {
  description = "ID of public Subnet 1"
  value =   aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "ID of public Subnet 2"
  value =   aws_subnet.public_subnet_2.id
}

output "private_subnet_1_id" {
  description = "ID of private Subnet 1"
  value =   aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  description = "ID of private Subnet 2"
  value =   aws_subnet.private_subnet_2.id
}

output "public_subnet_ids" {
  description = "ID of all public subnets"
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

output "public_route_table_az1_id" {
  description = "ID of the public route table"
  value = aws_route_table.public_route_table.id   
}

output "private_route_table_az1_id" {
  description = "ID of private route table AZ1"
  value = aws_route_table.private_route_table_az1.id
}

output "private_route_table_az2_id" {
  description = "ID of private route table AZ2"
  value = aws_route_table.private_route_table_az2.id
}

output "nat_gateway_az1_id" {
  description = "ID of NAT Gateway in AZ1"
  value = aws_nat_gateway.aws_nat_gateway_az1.id
}

output "nat_gateway_az2_id" {
  description = "ID of NAT Gateway in AZ2"
  value = aws_nat_gateway.aws_nat_gateway_az2.id
}