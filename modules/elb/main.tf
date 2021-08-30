resource "aws_lb" "lambda_function_access" {
  name               = var.elbName
  load_balancer_type = var.loadBalancerType
  security_groups    = [var.securityGroup]
  subnets            = var.publicSubnet

  # access_logs {
  #   bucket  = var.accessLogBucket
  #   prefix  = "access-log"
  #   enabled = true
  # }

  tags = {
    Environment = var.environment
  }
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lambda_function_access.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "lambda_target" {
  name        = var.targetGroupname
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpcId
  target_type = "lambda"
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda_target.arn
  }

  condition {
    path_pattern {
    values = ["/*"]
    }
  }
}

resource "aws_lb_target_group_attachment" "lambda_target_attach" {
  target_group_arn = aws_lb_target_group.lambda_target.arn
  target_id        = var.lambdaArn
}