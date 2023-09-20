# Auto Scaling Group
resource "aws_autoscaling_group" "web-asg-cicd" {
  name                 = "web-asg-cicd"
  launch_configuration = aws_launch_configuration.web-lc-1-cicd.name
  min_size             = 1
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.subnetz1-private-cicd.id, aws_subnet.subnetz2-private-cicd.id]

  target_group_arns = [aws_lb_target_group.alb-cicd_target_group.arn]

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}

# Create the first launch configuration
resource "aws_launch_configuration" "web-lc-1-cicd" {
  name_prefix          = "web-lc-1-cicd"
  image_id             = "ami-0b9094fa2b07038b8" # Replace with a valid BusyBox AMI ID
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.sg-private-cicd.id]

  user_data = <<-EOT
                #!/bin/sh
                busybox sh
                echo "Hello World"
              EOT

  lifecycle {
    create_before_destroy = true
  }
}

# Create an Auto Scaling Policy
resource "aws_autoscaling_policy" "scale-up-cicd-as-policy" {
  name                   = "cicd-scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30 # seconds
  autoscaling_group_name = aws_autoscaling_group.web-asg-cicd.name
}

# CloudWatch Metric Alarm to trigger the scaling policy
resource "aws_cloudwatch_metric_alarm" "scale-up-cicd-cloudwatch" {
  alarm_name          = "scale-up-on-high-requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1" 
  alarm_description   = "This metric triggers when there are too many requests on the ALB"
  alarm_actions       = [aws_autoscaling_policy.scale-up-cicd-as-policy.arn]
  dimensions = {
    LoadBalancer      = "app/${aws_lb.alb-cicd.name}/${aws_lb.alb-cicd.id}"
    AvailabilityZone  = "eu-central-1a"
  }
}
