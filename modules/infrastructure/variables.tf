variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "main_vpc"
}

variable "vpc_environment" {
  description = "The environment to deploy the infrastructure"
  type        = string
  default     = "dev"
}

variable "public_subnet_1_cidr_block" {
  description = "The CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr_block" {
  description = "The CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_1_name" {
  description = "Public Name for the first public subnet"
  type        = string
  default     = "public_subnet_1"
}

variable "public_subnet_2_name" {
  description = "Public Name for the second public subnet"
  type        = string
  default     = "public_subnet_2"
}

variable "internet_gateway_name" {
  description = "The name of internet Gateway"
  type        = string
  default     = "main_internet_gateway"
}

variable "availability_zone_1" {
  description = "The availability zone for the first subnet"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "The availability zone for the second subnet"
  type        = string
  default     = "us-east-1b"
}

variable "private_subnet_1_cidr_block" {
  description = "The CIDR block for the first private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr_block" {
  description = "The CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "private_subnet_1_name" {
  description = "Private Name for the first private subnet"
  type        = string
  default     = "private_subnet_1"
}

variable "private_subnet_2_name" {
  description = "Private Name for the second private subnet"
  type        = string
  default     = "private_subnet_2"
}

variable "public_subnet_map_public_ip_on_launch" {
  description = "value"
  type        = bool
  default     = true
}

variable "public_route_table_name" {
  description = "The name of route table"
  type        = string
  default     = "public_route_table"
}

variable "public_route_destination_cidr_block" {
  description = "Route Table destination CIDR block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "nat_eip_az1" {
  description = "Elatic IP for AZ1"
  type        = string
  default     = "nat-eip-az1"
}

variable "nat_eip_az2" {
  description = "Elatic IP for AZ2"
  type        = string
  default     = "nat-eip-az2"
}

variable "nat-gateway-az1" {
  description = "NAT Gateway for AZ1"
  type        = string
  default     = "nat-gateway-az1"
}

variable "nat-gateway-az2" {
  description = "NAT Gateway for AZ2"
  type        = string
  default     = "nat-gateway-az2"
}