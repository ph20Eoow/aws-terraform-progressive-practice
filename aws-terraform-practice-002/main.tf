module "webserver" {
  source = "./modules/web-server"
  vpc_id = aws_vpc.lab-vpc.id
  cidr_block = "10.0.1.0/24" 
  private_ip = "10.0.1.50"
  availability_zone = "us-west-2a"
  name = "web-us-w2a"
  gw_id = aws_internet_gateway.lab-gw.id
}
