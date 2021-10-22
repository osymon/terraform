#set provider
provider "aws" {
  region = "eu-central-1"
}
#set datasource
data "aws_availability_zones" "available" {}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
#key_pair
resource "aws_key_pair" "gogs-key" {
  key_name   = "gogs-key"
  public_key = file("gogs-key.pub")
}
#set-instance+eip
resource "aws_instance" "gogs" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.gogs.id]
  user_data              = file("install_gogs_Ubuntu_21.10.sh")
  key_name               = aws_key_pair.gogs-key.key_name

  #  lifecycle {
  #    prevent_destroy = true
  #  }

  tags = {
    Name = "gogs_server"
  }
}
resource "aws_eip" "gogs_eip" {
  instance = aws_instance.gogs.id
  vpc      = true
  tags = {
    Name = "publicip_for_googs"
  }
}
#set security group
resource "aws_security_group" "gogs" {
  name        = "gogssecgroupdynamic"
  description = "terraformsecgroup"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["77.121.11.57/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          #all protocols
    cidr_blocks = ["0.0.0.0/0"] #all ip
  }
  tags = {
    name  = "GOGsSecGroup"
    owner = "Oleksandr Symonenko"
  }
}
resource "aws_default_subnet" "def_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
