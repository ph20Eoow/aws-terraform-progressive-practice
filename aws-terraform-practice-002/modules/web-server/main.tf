terraform {
    required_version = ">=0.12"
}

resource "aws_subnet" "web-subnet"{
  vpc_id     =  var.vpc_id # "${aws_vpc.lab-vpc.id}"
  cidr_block = var.cidr_block #"10.0.1.0/24"
  availability_zone = var.availability_zone # "us-west-2a"
  
  tags = {
    Name = "lab-subnet-${var.name}"
  }
}

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.web-subnet.id
  private_ips     = [ var.private_ip ]
  security_groups = [ aws_security_group.security_group.id]
}


resource "aws_eip" "eip" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.private_ip
  depends_on = [ var.gw_id ]
}

resource "aws_instance" "web-instance" {
  depends_on = [ aws_key_pair.lab-key ]
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"
  availability_zone = var.availability_zone # "us-west-2a"
  key_name = "lab-key"
  
  network_interface {
    network_interface_id = aws_network_interface.web-server-nic.id 
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
        Name = "lab-${var.name}"
    }
}