terraform {
  backend "s3" {
    bucket = "thirty-tf-state"
    key    = "test/terraform.tfstate"
    region = "eu-west-1"

  }
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

provider "aws" {
  alias  = "ohio"
  region = "us-east-2"
  default_tags {
    tags = {
      "terraformed" = "True"
      "abroad" = "True"
    }
  }
}


resource "random_pet" "this" {
  length = 2
}

module "lambda" {
  count = 0
  source = "github.com/terraform-aws-modules/terraform-aws-lambda"
  function_name = "${random_pet.this.id}-lambda"
  handler       = "hello.lambda_handler"
  runtime       = "python3.9"
  publish       = true

  source_path = "${path.module}/python"
  hash_extra  = "yo1"
  create_lambda_function_url = true
  providers = {
    aws = aws.ohio
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

output "lambda_url" {
  value = toset(module.lambda[*].lambda_function_url)
}
