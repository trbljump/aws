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


module "lambda" {
  source = "./Lambda"
providers = {
  aws = aws.ohio
 }
}

resource "random_pet" "this" {
  length = 2
}

resource "aws_iam_policy" "lambda_policy" {
  name = "policy-${random_pet.this.id}"
  path        = "/"
  description = "Execution policy for ${random_pet.this.id}"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-east-2:036964189205:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-east-2:036964189205:log-group:/aws/lambda/${random_pet.this.id}:*"
            ]
        }
    ]
  })
}

resource aws_iam_role "lambda_role" {
  name = "role-${random_pet.this.id}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
  managed_policy_arns=  [
    aws_iam_policy.lambda_policy.arn
  ]
  provider = aws.ohio
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_lambda_function" "test_lambda" {
  provider = aws.ohio
  function_name = random_pet.this.id
  role = aws_iam_role.lambda_role.arn
  runtime = "python3.9"
  filename = "python/package.zip"
  handler = "hello.lambda_handler"
  publish = true
}

resource "aws_lambda_function_url" "test_lambda" {
  provider = aws.ohio
  function_name      = aws_lambda_function.test_lambda.function_name
  authorization_type = "NONE"
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
  value = aws_lambda_function_url.test_lambda.function_url
}