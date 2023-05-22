
output "ec2_public_ip" {
  value = aws_instance.ecs_bastion.public_ip
}

output "alb_hostname" {
  value = aws_lb.albdev.dns_name
}

output "efs_endpoint" {
  value = aws_efs_file_system.jenkins.dns_name
}

output "ecr_repo_endpoint" {
  value = aws_ecr_repository.ecr_repo.repository_url
}
