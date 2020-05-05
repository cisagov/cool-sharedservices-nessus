# A data source for the VPC in which the Nessus subnet lives
data "aws_vpc" "the_vpc" {
  id = data.aws_subnet.the_subnet.vpc_id
}
