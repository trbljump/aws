data "aws_ami" "amazonlinux" {
  most_recent = true
  owners = ["137112412989"] # Amazon
  name_regex = "^al2022-ami-minimal.*"
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}
resource "random_pet" "this" {
  length = 2
}

resource "aws_instance" "this" {
    ami = data.aws_ami.amazonlinux.image_id
    instance_type = "t4g.medium"
    key_name = var.ssh_key_id
    subnet_id = var.subnet_id
    security_groups = [var.security_group]
    user_data_replace_on_change = true
    user_data = <<EOF
#!/bin/sh

yum update --assumeyes
hostnamectl hostname ${random_pet.this.id} --transient
hostnamectl hostname ${random_pet.this.id} --static
EOF
}

resource "aws_eip" "this" {
    vpc = true
    instance = aws_instance.this.id
    associate_with_private_ip = aws_instance.this.private_ip
}
