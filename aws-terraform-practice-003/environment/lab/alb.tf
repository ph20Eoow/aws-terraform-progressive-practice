# Learn how to set up an ALB without terraform first ->
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-application-load-balancer.html#select-targets
#

resource "aws_lb" "lab-alb" {
  name               = "lab-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.security_group.id]
  subnets            = module.webserver.subnet_ids

  tags = {
    Name = "lab"
  }
}

resource "aws_lb_target_group" "lab-alb" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.lab-vpc.id
}

resource "aws_lb_target_group_attachment" "lab-alb" {
  count = length(module.webserver)
  target_group_arn = aws_lb_target_group.lab-alb.arn
  target_id        = module.webserver.instance_ids[count.index]
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lab-alb.arn
  port              = "80"
  # protocol          = "HTTPS"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lab-alb.arn
  }
}