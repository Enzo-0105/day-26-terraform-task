output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_id" {
  value = aws_subnet.public-sub.id
}

output "sg_id" {
  value = aws_security_group.web-sg.id
}