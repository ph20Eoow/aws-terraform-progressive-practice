# Goal 
- Setting up an Application Load Balancer (ALB) at load balance the traffic for the EC2 in the private subnet

# Learning Objective
- Make modules input accept map/list of string
- Create multiple resources in one module by processing map inputs
    - use of for_each
    - use of count to achieve iteration
- Understand how to create an Application Load Balancer
  - forwarding request from port 80 to web server hosted in different az
- Keep your web server at a private subnet while still maintaining it accessible from the Internet

# Limitation 
- In this example we are only using Application Load Balancer which only forwarding traffic for port 80 and 443, port 22 will not be forwarded. Thus, we lost our available to manange the instance via SSH


![](AWS-Terraform-Practice-003.png)
Source: https://docs.aws.amazon.com/prescriptive-guidance/latest/load-balancer-stickiness/subnets-routing.html