
provider "aws" {
	region="eu-central-1"
}

resource "aws_eip" "staticip" {
	instance = aws_instance.webserver.id
}

resource "aws_instance" "webserver" {
	ami="ami-03a71cec707bfc3d7"
	instance_type="t2.micro"
	vpc_security_group_ids= [aws_security_group.webserver.id]
	user_data=templatefile("./script.tpl", {
	  f_name="Oleksandr",
	  l_name="Symonenko",
	  names= ["vasia", "kolia", "maryna", "lilu"]


})
tags = {
	name= "WebServer"
	owner= "Oleksandr Symonenko"
}
depends_on=[aws_instance.bdserver]#not created if bdserver not created 
}
resource "aws_instance" "bdserver" {
	ami="ami-03a71cec707bfc3d7"
	instance_type="t2.micro"
	vpc_security_group_ids= [aws_security_group.webserver.id]
	user_data=templatefile("./script.tpl", {
	  f_name="Oleksandr",
	  l_name="Symonenko",
	  names= ["vasia", "kolia", "maryna", "lilu"]


})
tags = {
	name= "BDServer"
	owner= "Oleksandr Symonenko"
}
}

lifecycle {
	prevent_destroy = true
	#ignore_changes = ["ami","user_data","vpc_security_group_ids"] #ignore changes in this parameters
	#create_before_destroy=true #create newserver before destroy oldserver
}

resource "aws_security_group" "webserver" {
	name= "webserversecgroup"
	description="terraformsecgroup"


ingress {
	from_port=80
	to_port=80
	protocol="tcp"
	cidr_bloks= ["0.0.0.0/0"]
}
ingress {
	from_port=443
	to_port=443
	protocol="tcp"
	cidr_bloks= ["0.0.0.0/0"]
}

egress {
	from_port=0
	to_port=0
	protocol="-1" #all protocols
	cidr_bloks= ["0.0.0.0/0"] #all ip
}
tags = {
	name= "WebServerSecGroup"
	owner= "Oleksandr Symonenko"
}
