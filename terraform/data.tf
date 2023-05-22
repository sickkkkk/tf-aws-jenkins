data "aws_secretsmanager_secret_version" "bastion_key" {
  secret_id = "dev/bastion-key"
}