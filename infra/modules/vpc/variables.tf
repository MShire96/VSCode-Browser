variable "vpc_cidr_block" {
  type = string
}

variable "public_cidr" {
  type = list(string)
}


variable "private_cidr" {
  type = list(string)
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
