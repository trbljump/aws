resource "aws_instance" "this" {
    ami = var.instance_ami
    instance_type = "t3.nano"
    key_name = var.ssh_key_id
    subnet_id = var.subnet_id
    user_data_replace_on_change = true
    user_data = <<EOF
#!/bin/sh

yum update --assumeyes
yum install dovecot git --assumeyes
echo "Kilroy was there" > /etc/motd
EOF
}

resource "aws_eip" "this" {
    vpc = true
    instance = aws_instance.this.id
    associate_with_private_ip = aws_instance.this.private_ip
}
