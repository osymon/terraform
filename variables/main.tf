#variable

#set provider
provider "aws" {
  region = var.region
}
#set datasource
data "aws_ami" "latest_amazon-linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#set-instance+eip
resource "aws_instance" "myserver" {
  ami                    = data.aws_ami.latest_amazon-linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.myserver.id]

  /*
    lifecycle {
      prevent_destroy = true
    }
*/
  tags = merge(var.common_tags, { Name = "${var.common_tags["environment"]} myserver" })
}
resource "aws_eip" "myserver" {
  instance = aws_instance.myserver.id
  vpc      = true
  tags     = merge(var.common_tags, { Name = "${var.common_tags["environment"]} publicip_server" })
}
#set security group
resource "aws_security_group" "myserver" {
  name        = "secgroupdynamic"
  description = "terraformsecgroup"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"            #all protocols
    cidr_blocks = var.cidr_blocks #all ip
  }
  tags = merge(var.common_tags, { Name = "${var.common_tags["environment"]} serversecgroup" })
}
