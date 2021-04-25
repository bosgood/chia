# resource "aws_ebs_volume" "scratch" {
#   availability_zone = var.availability_zone
#   type              = var.scratch_volume_type
#   size              = var.scratch_volume_size_gb

#   tags = {
#     project = "chia"
#   }
# }

# resource "aws_ebs_volume" "plot1" {
#   availability_zone = var.availability_zone
#   type              = var.plot_volume_type
#   size              = var.plot_volume_size_gb

#   tags = {
#     project = "chia"
#   }
# }

# resource "aws_volume_attachment" "scratch" {
#   device_name = "/dev/sdf"
#   volume_id   = aws_ebs_volume.scratch.id
#   instance_id = aws_instance.farmer.id
# }

# resource "aws_volume_attachment" "plot1" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.plot1.id
#   instance_id = aws_instance.farmer.id
# }
