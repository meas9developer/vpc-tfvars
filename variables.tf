variable "envPrefix" {
  default = "POC-BlueGreen-change-dev4"
}

variable "azs" {
  description = "comma separated ordered lists of AZs in which to distribute subnets"
  default     = "us-west-2a,us-west-2b"
}


variable "defaultTags" {
  type = "map"

  default = {
    Name = ""$${var.billing}""
    Owner = ""$${var.project}""
  }
}

variable "billing" {
  default     = "DXinfra-billing"
}

variable "project" {
  default     = "DXinfra"
}

variable "awsRegion" {
  description = "region"
  default     = "us-west-2"
}

variable "ProjectTag" {
  description = "comma separated ordered lists of AZs in which to distribute subnets"
  default     = "us-west-2a,us-west-2b"
}


variable "cidr" {
  default = "10.0.5.0/24"
}
variable "lb_subnet_a_cidr" {
  default = "10.0.5.96/28"
}

variable "lb_subnet_b_cidr" {
  default = "10.0.5.16/28"
}

variable "db_subnet_a_cidr" {
  default = "10.0.5.32/28"
}

variable "db_subnet_b_cidr" {
  default = "10.0.5.48/28"
}

variable "web_subnet_a_cidr" {
  default = "10.0.5.64/28"
}

variable "web_subnet_b_cidr" {
  default = "10.0.5.80/28"
}
