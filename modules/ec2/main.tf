resource "aws_launch_template" "blue" {
  instance_type = var.instance_type
  image_id      = var.ami
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y 
sudo systemctl start apache2
EOF
  )
}