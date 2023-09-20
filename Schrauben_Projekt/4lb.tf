resource "aws_lb" "alb-cicd" {
  name               = "backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg-cicd.id]
   enable_deletion_protection        = false
  enable_cross_zone_load_balancing  = true
  enable_http2                      = true
  idle_timeout                      = 60
  subnets = [
    aws_subnet.subnetz1-oeffentlich-cicd.id,
    aws_subnet.subnetz2-oeffentlich-cicd.id
  ]
}

resource "aws_lb_target_group" "alb-cicd_target_group" {
  name     = "backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-cicd.id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 3 #kann raus zeile 15 - 25
    unhealthy_threshold = 2 
    interval            = 30
    timeout             = 3
    matcher             = "200"
  }
}

resource "aws_lb_listener" "web-listener-cicd" {
  load_balancer_arn = aws_lb.alb-cicd.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-cicd_target_group.arn
  }
}