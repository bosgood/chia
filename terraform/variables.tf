variable "availability_zone" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "scratch_volume_size_gb" {
  type    = number
  default = 2500
}

variable "scratch_volume_type" {
  type    = string
  default = "gp3"
}

variable "plot_volume_size_gb" {
  type    = number
  default = 1024
}

variable "plot_volume_type" {
  type    = string
  default = "sc1"
}

variable "farmer_user_data" {
  type        = string
  description = "CoreOS Ignition configuration"
}

variable "home_ips" {
  type        = list(string)
  description = "Your home IP address CIDRs (probably ends with /32)"
}
