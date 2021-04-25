resource "aws_key_pair" "laptop" {
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

resource "aws_instance" "farmer_amzn" {
  # Amazon Linux 2 HVM
  # https://aws.amazon.com/amazon-linux-2/faqs/
  ami = "ami-0742b4e673072066f"

  availability_zone = var.availability_zone
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.chia.id
  key_name          = aws_key_pair.laptop.key_name

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_all_outbound.id,
  ]

  tags = {
    project = "chia"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
}

# resource "aws_instance" "farmer_fcos" {
#   # Fedora CoreOS
#   # https://getfedora.org/coreos/download?tab=cloud_launchable&stream=stable
#   ami       = "ami-06af204ec574cc791"
#   user_data = var.farmer_user_data

#   availability_zone = var.availability_zone
#   instance_type     = "t2.micro"
#   subnet_id         = aws_subnet.chia.id
#   key_name          = aws_key_pair.laptop.key_name

#   vpc_security_group_ids = [
#     aws_security_group.allow_ssh.id,
#     aws_security_group.allow_all_outbound.id,
#   ]

#   tags = {
#     project = "chia"
#   }

#   root_block_device {
#     volume_size = 10
#     volume_type = "gp3"
#   }
# }
