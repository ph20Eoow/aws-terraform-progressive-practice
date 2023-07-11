# Goal 
- Creating an EC2 instance that allow user access through the Internet
- Allowing admin access via SSH to the EC2 and install the web server

# Learning Objective
- Understand the AWS services/components including
  - VPC
  - Internet Gateway
  - Subnet
  - Security Group
- How to configure Routing and ACL 
- How to assign an elastic IP to the network interface 
- How to spawn an EC2 instance 

# Steps 
1. Create VPC
2. Create Route Table
3. Create Internet Gateway
4. Creat a Subnet
5. Associate subnet with Route Table
6. Create Security Group allow traffics from prot 22, 80
7. Create a network interface with an IP in the subnet
8. Assign an elastic IP to the network interface
9. Create Key Pair
10. Create an EC2 runing Ubuntu and install apache2

![](AWS-Terraform-Practice-001.jpeg)