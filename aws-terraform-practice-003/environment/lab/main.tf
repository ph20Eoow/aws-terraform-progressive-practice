module "webserver" {
  source             = "../../modules/web-server"
  vpc_id             = aws_vpc.lab-vpc.id
  subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  private_ips         = ["10.0.1.50", "10.0.2.50"]
  availability_zone  = ["us-west-2a", "us-west-2b"]
  gw_id              = aws_internet_gateway.lab-gw.id
  security_group_id  = aws_security_group.security_group.id
}
