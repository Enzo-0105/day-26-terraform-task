variable "lb_type" {
  type = string
  default = "application"
}

variable "sg" {
  type = string
  default = ""
}

variable "vpc" {
  type = string
  default = ""
}

variable "subnet" {
  type = string
  default = ""
}

variable "name" {
  type = string
  default = "web-lb"
}

variable "port" {
  type = string
  default = "80"
}

variable "lb-action" {
  type = string
  default = "forward"
}

variable "protocol" {
  type = string
  default = "HTTP"
}

variable "target_type" {
  type = string
  default = "instance"
}

variable "target_group_name" {
  type = string
  default = "web-lb-target"
}

variable "internal_lb" {
  type = bool
  default = false
}
