provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "lab-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "lab"
  }
}

resource "aws_internet_gateway" "lab-gw" {
  vpc_id = aws_vpc.lab-vpc.id

  tags = {
    Name = "lab"
  }
}

resource "aws_subnet" "lab-subnet-1" {
  vpc_id     = "${aws_vpc.lab-vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  
  tags = {
    Name = "lab-subnet"
  }
}

resource "aws_route_table" "lab-route-table" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-gw.id
  }

  tags = {
    Name = "lab"
  }
}

resource "aws_route_table_association" "lab-subnet-1-attach-rt" {
    subnet_id = "${aws_subnet.lab-subnet-1.id}"
    route_table_id = "${aws_route_table.lab-route-table.id}"
}

resource "aws_security_group" "allow-web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.lab-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "http from VPC"
    from_port        =  80
    to_port          =  80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "ssh from VPC"
    from_port        = 22 
    to_port          =   22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.lab-subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow-web.id]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = "${aws_network_interface.web-server-nic.id}"
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.lab-gw]
}

resource "aws_key_pair" "lab-key" {
  key_name   = "lab-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZI+HzwPAM+NPf2pvWKZI34vhmETt8hV2pTMyDQtsgTrUMcBqIOwUWl1kwO6eZxt+JBn7YOw38oQqCSMX6mPXakn0ZJToNHLI4sbtnTGRM3D2PES6BAXqZOCffN9PO5R7RbNQVeJt6hPf2gf6jvKOu4qsJdSrvdX5Jxemx2kQx2RY5twm4aNVE0uknkOjtnnVt5KdUEslyj3Zhk3ZBjISQC/+22mSqkWeT59QAzs2uRVuSqYnFxC+G3DSJUz34r6Yb7EkF28u1Iyay+OsAeODQnXYSHdRAu7SMCmYGFt24ITruu40guO/6Hvw/Fx7e18eLvwLrMlfl2+MiVI/IhlUzffZ/QzpwO7bWly8p9p5qWGoVf4wVHzLDoEr6xSY3pTZU7eAiC0x7FRzvEAK35nfhyRXHzbgkI92Md8ZV2KTXRc3dhgWdj9x1fHyHwHyjIkrg1djaycv7GPOGMfVEjofAyxfIBCH7wBXgQcNMbweDNDAmWOT67IxuwBc79w+0mTk="
}

resource "aws_instance" "webserver" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"
  key_name = "lab-key"
  depends_on = [ aws_key_pair.lab-key ]
  network_interface {
    network_interface_id = aws_network_interface.web-server-nic.id
    device_index         = 0
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo web server > /var/www/html/index.html'
                EOF
    tags = {
        Name = "lab"
    }
}

