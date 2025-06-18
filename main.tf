terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  shared_credentials_files = [var.creds_file]
  region                   = "us-east-1"
}

resource "aws_instance" "docker_server" {
  ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-defaultx86_64"
  instance_type = "t3.medium"
  subnet_id = "subnet-084e7f1e3ce1f633a"
  vpc_security_group_ids = ["sg-084b8f1393497c678"]
  tags = {
    Name = "DockerServer"
  }
  user_data = "${file('init.sh')}"
}
