output "subnet_ids" {
    value = aws_subnet.web-subnet[*].id
}

output "instance_ids" {
    value = aws_instance.web-instance[*].id
}