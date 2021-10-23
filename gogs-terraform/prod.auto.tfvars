#File can be names as:
#terraform.tfvars
#prod.auto.tfvars
#dev.auto.tfvars
#File can be apply:
#terraform apply -var-file="prod.auto.tfvars"

region        = "eu-central-1"
instance_type = "t2.micro"
allow_ports   = ["80", "443"]
common_tags = {
  owner       = "Oleksandr Symonenko"
  project     = "myserver"
  environment = "prodaction"
}
