# Determine all of the available availability zones in the
# current AWS region.
data "aws_availability_zones" "available" {
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_region" "current" {}