terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      "terraformed" = "True"
    }
  }
}

module "machine" {
  source = "./Machines"
  count = 0

  ssh_key_id = aws_key_pair.jmp.id
  instance_ami = var.test_instance_ami
  subnet_id = aws_subnet.machines.id
}

output "public_ip" {
  value = module.machine[*].public_ip
}

