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

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.chia.id

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.home_ips
  }

  tags = {
    project = "chia"
  }
}

resource "aws_security_group" "allow_all_outbound" {
  name        = "allow_all_outbound"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.chia.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    project = "chia"
  }
}

resource "aws_security_group" "chia_farmer" {
  name   = "chia_farmer"
  vpc_id = aws_vpc.chia.id

  tags = {
    project = "chia"
  }
}

resource "aws_security_group" "allow_ssh_chia_farmer" {
  name        = "allow_ssh_chia_farmer"
  description = "Allow SSH inbound traffic to chia-farmer"
  vpc_id      = aws_vpc.chia.id

  ingress {
    description = "SSH to chia-farmer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.home_ips
  }

  tags = {
    project = "chia"
  }
}
