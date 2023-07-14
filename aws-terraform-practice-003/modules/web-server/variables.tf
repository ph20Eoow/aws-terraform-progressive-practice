variable "vpc_id" {
    type = string
}

variable "availability_zone" {
    type = list(string)
}

variable "subnet_cidr_blocks" {
    type = list(string)
    description = "assign a cidr block for new subnet"
}

variable "private_ips" {
    type = list(string)
}

# this variable will be used for depends on input when the internet-gateway is ready
variable "gw_id" {
     type = string
}

variable "security_group_id" {
    type = string
}

