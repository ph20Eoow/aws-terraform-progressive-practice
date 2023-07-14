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
    count = length(module.webserver)
    subnet_id =  module.webserver.subnet_ids[count.index]
    route_table_id = "${aws_route_table.lab-route-table.id}"
}