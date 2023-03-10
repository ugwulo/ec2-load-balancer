# Create Application Load balancer
resource "aws_lb" "lb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.igw_sg.id, ]
  subnets            = aws_subnet.public_subnets.*.id
}

# Create target group
resource "aws_lb_target_group" "tg" {
  name        = "TargetGroup"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ugwulo_vpc.id

  health_check {
    port     = var.health_check.port
    matcher  = var.health_check.matcher
    path     = var.health_check.path
    protocol = var.health_check.protocol
  }
}


# Target Group Attachment with Instance
resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = length(aws_instance.ubuntu.*.id) == 3 ? 3 : 0
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(aws_instance.ubuntu.*.id, count.index)
}




# Create a listener
resource "aws_lb_listener" "web_server" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}