# Determine all of the available availability zones in the
# current AWS region.
data "aws_availability_zones" "available" {
    filter {
      name = "state"
      values = ["available"]
    }
}

# This additional data source determines some additional
# details about each VPC, including its suffix letter.
data "aws_availability_zone" "all" {
  for_each = aws_avaiability_zones.available.names

  name = each.key
}