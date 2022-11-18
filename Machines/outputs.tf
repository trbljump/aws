output "public_ip" {
    value = aws_eip.this.public_ip
}

output "test_instance_public_hostname" {
    value = aws_eip.this.public_dns
}

output "test_instance_id" {
    value = aws_instance.this.id
}
