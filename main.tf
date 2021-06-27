terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-east-1"
}

resource "aws_instance" "iis_server" {
  ami           = "ami-0fc1e19ae26e5feb3"
  instance_type = "t3.micro"
  key_name      = "nuvoni_ap-east-2"

  vpc_security_group_ids = [
      aws_security_group.allow_win_access.id
  ]

  tags = {
    Name = "WindowsServerIIS"
  }
}

resource "aws_security_group" "allow_win_access" {
  name        = "sg_allow_win_access"
  description = "Allow Access"

  ingress {
    description      = "WINRD"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "WINRM"
    from_port        = 5986
    to_port          = 5986
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "IIS"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_win_access"
  }
}