
resource "aws_lb" "albdev" {
  name               = "albdev"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_dev.id]
  subnets            = [aws_subnet.ecs_subnet_2.id, aws_subnet.ecs_subnet_3.id]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}


resource "aws_lb_listener" "albdev" {
  load_balancer_arn = aws_lb.albdev.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:eu-central-1:623180997824:certificate/bba68624-9902-4a54-a3c6-ef6e4107d9ed"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albdev.arn
  }
}


resource "aws_lb_target_group" "albdev" {
  name        = "dev-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecs_vpc.id


  health_check {
    healthy_threshold   = "2"
    interval            = "90"
    protocol            = "HTTP"
    port                = "8080"
    matcher             = "200"
    timeout             = "60"
    path                = "/login"
    unhealthy_threshold = "7"
  }  
}

resource "aws_route53_record" "jenkins-dev" {
  zone_id = var.r53_zone_id
  name    = var.alb_alias
  type    = "A"

  alias {
    name                   = aws_lb.albdev.dns_name
    zone_id                = aws_lb.albdev.zone_id
    evaluate_target_health = true
  }
}