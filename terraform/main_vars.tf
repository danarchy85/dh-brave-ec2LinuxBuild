
# Infrastructure variables
variable "aws_region" {
  description = "AWS Region"
  type = string
  default = "us-west-1"
}

variable "project_name" {
  description = "Project Name prefix for AWS tags"
  type = string
  default = "dh-brave"
}

variable "aws_ami" {
  description = "AWS EC2 Image"
  type = string
  default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210430"
}

variable "aws_ami_owner" {
  description = "AWS AMI Onwer"
  type = string
  default = "099720109477"
}

variable "instance_size" {
  description = "Instance size"
  type = string
  default = "t2.micro"
}

variable "root_volume_size" {
  description = "Root volume size (GiB)"
  type = number
  default = "8"
}

# npmrc variables
variable "brave_stats_updater_url" {
  description = "Brave stats updater url"
  type = string
  default = "https://example.com"
}

variable "brave_sync_endpoint" {
  description = "Brave sync endpoint"
  type = string
  default = "https://example.com"
}

variable "brave_variations_server_url" {
  description = "Brave variations server url"
  type = string
  default = "https://example.com"
}

variable "uphold_client_id" {
  description = "Uphold client Id"
  type = string
  default = "dh-brave-build-client-id"
}

variable "uphold_client_secret" {
  description = "Uphold client secret"
  type = string
  default = "YOUR_SECRET"
}
