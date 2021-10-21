#provider & availability_zones
provider "aws" {
  region = "eu-central-1"
}


data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazon-linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#dynamic security group
resource "aws_security_group" "webserver" {
  name        = "webserversecgroupdynamic"
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          #all protocols
    cidr_blocks = ["0.0.0.0/0"] #all ip
  }
  tags = {
    name  = "WebServerSecGroup"
    owner = "Oleksandr Symonenko"
  }
}
#lounch configuration
resource "aws_launch_configuration" "webserver" {
  #name = "gbf"
  name_prefix     = "webserver_ha-"
  image_id        = data.aws_ami.latest_amazon-linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.webserver.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}
#auto scaling group

resource "aws_autoscaling_group" "webserver" {
  name                 = "asg-${aws_launch_configuration.webserver.name}"
  launch_configuration = aws_launch_configuration.webserver.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.def_az1.id, aws_default_subnet.def_az2.id]
  load_balancers       = [aws_elb.loadbalanser.name]

  dynamic "tag" {
    for_each = {
      Name   = "webserver_ha_asg"
      Owner  = "Oleksandr Symonenko"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
#load_balanser

resource "aws_elb" "loadbalanser" {
  name               = "webserver-ha-elb"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.webserver.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "webserver-ha-elb"
  }
}
resource "aws_default_subnet" "def_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "def_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}
