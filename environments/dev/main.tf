module "infrastructure" {
  source = "../../modules/infrastructure"

  # variables for the infrastructure module
  vpc_name = "dev-vpc"
  vpc_environment = "dev"
  internet_gateway_name = "dev-internet-gateway"
  public_subnet_1_name = "dev-public-subnet-1"
  public_subnet_2_name = "dev-public-subnet-2"
  private_subnet_1_name = "dev-private-subnet-1"
  private_subnet_2_name = "dev-private-subnet-2"
  public_route_table_name = "dev-public-route-table"
  private_route_table_az1_name = "dev-private-route-table-az1"
  private_route_table_az2_name = "dev-private-route-table-az2"
  nat_eip_az1 = "dev-nat-eip-az1"
  nat_eip_az2 = "dev-nat-eip-az2"
  nat_gateway_az1 = "dev-nat-gateway-az1"
  nat_gateway_az2 = "dev-nat-gateway-az2"
  public_subnet_1_cidr_block = "10.0.1.0/24"
  public_subnet_2_cidr_block = "10.0.2.0/24"
  private_subnet_1_cidr_block = "10.0.3.0/24"
  private_subnet_2_cidr_block = "10.0.4.0/24"
  public_route_destination_cidr_block = "0.0.0.0/0"
  public_subnet_map_public_ip_on_launch = true
}