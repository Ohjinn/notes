terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

# Create ec2
resource "aws_instance" "test_ec2" {
  
  instance_type = "t2.micro"
  key_name = "HJ-TEST-KPAIR"
  ami = "ami-02c329a4b4aba6a48"
  associate_public_ip_address = true
  subnet_id = "subnet-059060bb03a248e0a"
}

