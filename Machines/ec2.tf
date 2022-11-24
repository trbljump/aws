data "aws_ami" "amazonlinux" {
  most_recent = true
  owners = ["136693071363"] # Amazon
  name_regex = "^debian-11-amd64.*"
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
resource "random_pet" "this" {
  length = 2
}

resource "aws_instance" "this" {
    ami = data.aws_ami.amazonlinux.image_id
    instance_type = "t3.nano"
    key_name = var.ssh_key_id
    subnet_id = var.subnet_id
    security_groups = [var.security_group]
    user_data_replace_on_change = true
    user_data = <<EOF
#!/bin/sh

apt update && apt dist-upgrade --yes
EOF
}

resource "aws_eip" "this" {
    vpc = true
    instance = aws_instance.this.id
    associate_with_private_ip = aws_instance.this.private_ip
}
