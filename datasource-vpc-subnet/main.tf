provider "aws" {}

resource "aws_vpc" "prod" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "prod"
  }
}

data "aws_availability_zones" "work" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "myvpc" {}

data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "prod_sub_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.work.names[0]
  cidr_block        = "10.10.1.0/24"
  tags = {
    name    = "sub_1 in ${data.aws_availability_zones.work.names[0]}"
    account = "sub_1 in ${data.aws_caller_identity.current.account_id}"
    region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_sub_2" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.work.names[1]
  cidr_block        = "10.10.2.0/24"
  tags = {
    name    = "sub_2 in ${data.aws_availability_zones.work.names[1]}"
    account = "sub_2 in ${data.aws_caller_identity.current.account_id}"
    region  = data.aws_region.current.description
  }
}
