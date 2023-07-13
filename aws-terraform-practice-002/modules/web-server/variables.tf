variable "vpc_id" {
    type = string
}

variable "availability_zone" {
    type = string
}

variable "name" {
    type = string
}

variable "cidr_block" {
    type = string
    description = "assign a cidr block for new subnet"
}

variable "private_ip" {
    type = string
}

# this variable will be used for depends on input when the internet-gateway is ready
variable "gw_id" {
     type = string
}