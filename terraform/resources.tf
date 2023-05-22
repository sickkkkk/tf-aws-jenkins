data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}


resource "aws_key_pair" "ssh_key" {
  key_name = "ecs-bastion"
  public_key = data.aws_secretsmanager_secret_version.bastion_key.secret_string
}


resource "aws_instance" "ecs_bastion" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ecs_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ecs-bastion-sg.id]
  availability_zone = var.avail_zone1
  
  iam_instance_profile = aws_iam_instance_profile.bastion_bootstrap_role-profile.name

  associate_public_ip_address = true

  key_name = aws_key_pair.ssh_key.key_name

  user_data = file("bastion-entry-script.sh")


  tags = {
    Name = "ecs-ec2-bastion"
  }
}


