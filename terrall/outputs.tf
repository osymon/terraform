
output "webserver_instance_id" {
  value = "aws_instance.webserver.id"
}

output "webserver_public_ip_addr" {
  value = "aws_eip.staticip.public_ip"
}

output "webserver_sg_id" {
  value = "aws_security_group.webserver.id"
}
