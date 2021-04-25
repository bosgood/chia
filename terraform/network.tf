resource "aws_vpc" "chia" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    project = "chia"
  }
}

resource "aws_subnet" "chia" {
  vpc_id                  = aws_vpc.chia.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    project = "chia"
  }
}

resource "aws_internet_gateway" "chia" {
  vpc_id = "${aws_vpc.chia.id}"
}

resource "aws_route_table" "chia" {
  vpc_id = "${aws_vpc.chia.id}"
}

resource "aws_main_route_table_association" "chia" {
  vpc_id         = "${aws_vpc.chia.id}"
  route_table_id = "${aws_route_table.chia.id}"
}

resource "aws_route" "chia" {
  route_table_id         = "${aws_route_table.chia.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.chia.id}"
}

resource "aws_network_acl" "chia" {
  vpc_id = "${aws_vpc.chia.id}"

  subnet_ids = [
    "${aws_subnet.chia.id}",
    # "${aws_subnet.subnet2.id}",
    # "${aws_subnet.subnet3.id}",
  ]

  ingress {
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
    rule_no    = "100"
    action     = "allow"
    protocol   = "-1"
  }

  egress {
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
    rule_no    = "100"
    action     = "allow"
    protocol   = "-1"
  }
}
