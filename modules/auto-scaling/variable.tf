variable "min_size" {
  type = number
  default = 1
}
variable "desire_size" {
  type = number
  default = 1
}
variable "max_size" {
  type = number
  default = 1
}
variable "subnets" {
  type = list(string)
  default = [""]
}
variable "launch_template" {
  type = string
  default = ""
}


variable "target_group" {
  type = list(string)
  default = [""]
}
