output "aws_subnet_1_id" {
  value = aws_subnet.prod_sub_1.id
}
output "aws_subnet_1_tags" {
  value = aws_subnet.prod_sub_1.tags
}

output "aws_subnet_2_id" {
  value = aws_subnet.prod_sub_2.id
}
output "aws_subnet_2_tags" {
  value = aws_subnet.prod_sub_2.tags
}

output "data_aws_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}
output "data_aws_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block
}
output "data_aws_vpcs" {
  value = data.aws_vpcs.myvpc.ids
}
output "data_aws_availability_zones" {
  value = data.aws_availability_zones.work.names
}
output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}
output "data_aws_region_name" {
  value = data.aws_region.current.name
}
output "data_aws_region_description" {
  value = data.aws_region.current.description
}
