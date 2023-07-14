terraform {
    required_version = ">=0.12"
}

resource "aws_subnet" "web-subnet"{
  count = length(var.subnet_cidr_blocks)
  vpc_id     =  var.vpc_id # "${aws_vpc.lab-vpc.id}"
  cidr_block = var.subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zone[count.index] # "us-west-2a"
  
  tags = {
    Name = "lab-subnet-${local.name}"
  }
}

resource "aws_network_interface" "web-server-nic" {
  count = length(aws_subnet.web-subnet)
  subnet_id       = aws_subnet.web-subnet[count.index].id
  private_ips     = [ var.private_ips[count.index] ]
  security_groups = [ var.security_group_id ]
}


# resource "aws_eip" "eip" {
#   count = length(aws_network_interface.web-server-nic)
#   network_interface         = aws_network_interface.web-server-nic[count.index].id
#   associate_with_private_ip = var.private_ips[count.index]
#   depends_on = [ var.gw_id ]
# }

resource "aws_instance" "web-instance" {
  count = length(aws_network_interface.web-server-nic)
  depends_on = [ aws_key_pair.lab-key ]
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"
  availability_zone = var.availability_zone[count.index] # "us-west-2a"
  key_name = "lab-key"
  
  network_interface {
    network_interface_id = aws_network_interface.web-server-nic[count.index].id
    device_index         = 0
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo web server from $(hostname) > /var/www/html/index.html'
                EOF
    tags = {
        Name = "lab-${local.name}"
    }
}