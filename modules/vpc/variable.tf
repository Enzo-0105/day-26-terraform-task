variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public-cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "local_Tf" {
  description = "This is to specify if it was provisioned by terraform on the ui"
  type    = string
  default = "True"
}

variable "public-cidr1" {
  type    = string
  default = "10.0.23.0/24"
}

variable "private-cidr" {
  type    = string
  default = "10.0.8.0/24"
}

variable "env" {}
variable "az" {
  type = map(string)
  default = {
    "az1" = "us-east-1a"
    "az2" = "us-east-1b"
  }
}

variable "ingress_cidr" {
  description = "This is to decide the ip range that can have access to resources"
  type = string
  default = "0.0.0.0/0"
}