output "eip-myserver-id" {
  value = aws_eip.myserver.public_ip
}
output "eip-myserver-dns" {
  value = aws_eip.myserver.public_dns
}
output "latest_amazon_ami-id" {
  value = data.aws_ami.latest_amazon-linux.id
}
output "latest_amazon_ami-name" {
  value = data.aws_ami.latest_amazon-linux.name
}
output "security_group-id" {
  value = aws_security_group.myserver.id
}
