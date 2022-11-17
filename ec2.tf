/*
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["102837901569"] # Amazon

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  
  filter {
    name = "platform"
    values = ["Amazon linux"]
  }

}
*/

 resource "aws_key_pair" "jmp" {
  key_name   = "jmp-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDy75HsLgTtgiPsTnmMZCGP94X3wjnW2o2nsVGJ4vy/2DrPs3rkN748/OavmRPnFaYk9hn4jDlaLfBu9t1GJ+UvHUkjiDSsOk/YMpvqzs1AR4J+5RuFGn2emrtrctScDsKy+K2Dzk13sUNVJbCgcxG5UnwBw0sv9ZBlvvjBCpieRfIGTRRNQLsrEH2xF0h8cdPPcMJKeXO4qmKs3Mc1QTRV9P5HRcGF3QiyXYn08LQV7tHUZ4UBFk7o/xlTHx/IfRbL80tMjmTTjG+Wcjn3+Y23IcuxxTZOyrkzH1SchreN6Io8jTjCdTbsafd+3XUV1JjmpSodoRGVtkpDrodfvKhT jmp@Lightair.local"
  }

resource "aws_network_interface" "test" {
    subnet_id       = aws_subnet.test.id
    security_groups = [aws_security_group.test.id]
}

resource "aws_instance" "test" {
    ami = var.test_instance_ami // data.aws_ami.amazon_linux.id
    instance_type = "t3.nano"
    key_name = aws_key_pair.jmp.key_name
    network_interface {
        network_interface_id = aws_network_interface.test.id
        device_index         = 0
    }
}

resource "aws_eip" "test" {
    vpc = true
    instance = aws_instance.test.id
    associate_with_private_ip = aws_instance.test.private_ip
  depends_on                = [aws_internet_gateway.test]
}

output "test_instance_public_ip" {
    value = aws_eip.test.public_ip
}

output "test_instance_public_hostname" {
    value = aws_eip.test.public_dns
}

output "test_instance_id" {
    value = aws_instance.test.id
}
