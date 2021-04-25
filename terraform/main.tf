resource "aws_ebs_volume" "scratch" {
  availability_zone = var.availability_zone
  type              = var.scratch_volume_type
  size              = var.scratch_volume_size_gb

  tags = {
    project = "chia"
  }
}

resource "aws_ebs_volume" "plot1" {
  availability_zone = var.availability_zone
  type              = var.plot_volume_type
  size              = var.plot_volume_size_gb

  tags = {
    project = "chia"
  }
}

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

resource "aws_key_pair" "laptop" {
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

resource "aws_instance" "farmer" {
  # # Fedora CoreOS
  # # https://getfedora.org/coreos/download?tab=cloud_launchable&stream=stable
  # ami               = "ami-06af204ec574cc791"

  # Amazon Linux 2018.03
  # https://aws.amazon.com/amazon-linux-ami/
  ami = "ami-0ff8a91507f77f867"

  availability_zone = var.availability_zone
  instance_type     = "t2.micro"
  user_data         = var.farmer_user_data
  subnet_id         = aws_subnet.chia.id
  key_name          = aws_key_pair.laptop.key_name

  vpc_security_group_ids = [
    aws_security_group.chia_farmer.id,
    aws_security_group.allow_ssh_chia_farmer.id,
  ]

  tags = {
    project = "chia"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_volume_attachment" "scratch" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.scratch.id
  instance_id = aws_instance.farmer.id
}

resource "aws_volume_attachment" "plot1" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.plot1.id
  instance_id = aws_instance.farmer.id
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
