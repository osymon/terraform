output "eip-gogs-id" {
  value = aws_eip.gogs_eip.public_ip
}
output "eip-gogs-dns" {
  value = aws_eip.gogs_eip.public_dns
}
output "latest_ubuntu_ami-id" {
  value = data.aws_ami.latest_ubuntu.id
}
output "latest_ubuntu_ami-name" {
  value = data.aws_ami.latest_ubuntu.name
}
output "security_group-id" {
  value = aws_security_group.gogs.id
}
