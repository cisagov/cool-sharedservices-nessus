# A data source for the subnet where the Nessus instance should live
data "aws_subnet" "the_subnet" {
  id = local.nessus_subnet.id
}
