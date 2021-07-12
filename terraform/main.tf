
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.49.0"
    }
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "allow_ssh" {
  name = "${var.project_name}-sg-ssh-ingress"
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
    Project = var.project_name
    Name = "${var.project_name}-sg-ssh-ingress"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = [var.aws_ami]
  }

  owners = [var.aws_ami_owner]
}

data "template_file" "npmrc" {
  template = "${file("./templates/npmrc.tpl")}"

  vars = {
    brave_stats_updater_url = var.brave_stats_updater_url
    brave_sync_endpoint = var.brave_sync_endpoint
    brave_variations_server_url = var.brave_variations_server_url
    uphold_client_id = var.uphold_client_id
    uphold_client_secret = var.uphold_client_secret
  }
}

resource "aws_instance" "linux-build" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_size

  key_name = "${var.project_name}-kp-LinuxBuild"
  security_groups = [aws_security_group.allow_ssh.name]

  root_block_device {
    volume_size = var.root_volume_size
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/home/dan/.ssh/${var.project_name}-kp-LinuxBuild.pem")
  }

  provisioner "file" {
    content = data.template_file.npmrc.rendered
    destination = "/home/ubuntu/.npmrc"
  }

  provisioner "file" {
    source = "./scripts/user_data.sh"
    destination = "/home/ubuntu/user_data.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/user_data.sh",
      "/home/ubuntu/user_data.sh >> /tmp/user_data.log"
    ]
  }

  tags = {
    Project = var.project_name
    Name = "${var.project_name}-ec2-LinuxBuild"
  }
}
