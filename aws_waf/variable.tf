variable "ip_set_scope" {
  type = string
  default = "CLOUDFRONT"
}

variable "ip_address_version" {
  type = string
  default = "IPV4"
}

#For CLOUDFRONT need region US East (N. Virginia)
variable "aws_region" {
  default = "us-east-1"
}

# variable "addresses" {
#   type        = list(string)
#   description = "The Filename to import IP sets. Specify one or more IP addresses  contains by CIDR notation."
#   default     = [
# "85.239.56.23/32",
# "185.94.32.182/32",
# "93.177.117.93/32",
# "85.209.149.183/32",
# "88.218.46.23/32",
# "193.233.83.134/32",
# "193.202.16.73/32",
# "193.233.138.215/32",
# "85.208.86.160/32",
# "85.239.57.25/32",
# "212.119.40.165/32",
# "45.10.165.22/32",
# "213.166.79.12/32"
#   ]
# }