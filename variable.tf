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

variable "public-cidr1" {
  type    = string
  default = "10.0.23.0/24"
}

variable "private-cidr" {
  type    = string
  default = "10.0.8.0/24"
}

variable "env" {}