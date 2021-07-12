
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.49.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

provider "github" {}

resource "aws_security_group" "allow_ssh" {
  name = "dh-brave-sg-ssh-ingress"
  description = "Allow SSH ingress"

  ingress {
    description = "SSH ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "dh-brave-sg-ssh-ingress"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210430"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "linux-build" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name = "dh-brave-kp-LinuxBuild"
  security_groups = ["dh-brave-sg-ssh-ingress"]

  provisioner "file" {
    source = "./scripts/npmrc"
    destination = "/home/ubuntu/.npmrc"
  }

  provisioner "file" {
    source = "./scripts/user_data.sh"
    destination = "/home/ubuntu/user_data.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chown ubuntu:ubuntu /home/ubuntu/user_data.sh",
      "chmod +x /home/ubuntu/user_data.sh",
      "/home/ubuntu/user_data.sh >> /tmp/user_data.log"
    ]
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/home/dan/.ssh/dh-brave-kp-LinuxBuild.pem")
  }

  tags = {
    Name = "dh-brave-ec2-LinuxBuild"
  }
}
