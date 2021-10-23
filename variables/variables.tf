variable "region" {
  description = "Please Enter AWS region to deploy project"
  type        = string
  default     = "eu-central-1"
}
variable "instance_type" {
  description = "Please Enter AWS instance_type to deploy project "
  type        = string
  default     = "t2.micro"
}
variable "allow_ports" {
  description = "Please Enter AWS allow_ports to deploy project"
  type        = list(any)
  default     = ["80", "443", "8080"]
}
variable "cidr_blocks" {
  description = "Please Enter AWS cidr_blocks to deploy project"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(any)
  default = {
    owner       = "Oleksandr Symonenko"
    project     = "myserver"
    environment = "prodaction"
  }
}
