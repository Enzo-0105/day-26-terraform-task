provider "aws" {
  region = var.region
}

data "aws_ami" "web" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/*"]
  }
}

locals {
  name = "web-server"
  Terraform = "true"
  Environment = var.env 
}

locals {
  common_tags = {
    Name = local.name
    Terraform = local.Terraform
    Environment = local.Environment
  }
}
#Vpc creation for our application Network
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc

  tags = {
    Name      = "Web-server-vpc"
    Terraform = "Yes"
  }
}

#public Subnet creation
resource "aws_subnet" "public-sub" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public-cidr
  availability_zone = "us-east-1a"

  tags = {
    Name      = "web-server-public-sub"
    Terraform = "yes"
  }
}
resource "aws_subnet" "public-sub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public-cidr1
  availability_zone = "us-east-1b"

  tags = {
    Name      = "web-server-public-sub1"
    Terraform = "yes"
  }
}

#private subnet creation 
resource "aws_subnet" "private-sub" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private-cidr

  tags = {
    Name      = "web-server-private-subnet"
    Terraform = "yes"
  }
}

#Internet gateway for vpc
resource "aws_internet_gateway" "web-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "web-igw"
    Terraform = "yes"
  }
}

#Route table for vpc
resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-igw.id
  }
}

#associating the public subnet
resource "aws_route_table_association" "rt-ass" {
  subnet_id      = aws_subnet.public-sub.id
  route_table_id = aws_route_table.web-rt.id
}

resource "aws_route_table_association" "rt-assoc" {
  subnet_id      = aws_subnet.public-sub1.id
  route_table_id = aws_route_table.web-rt.id
}

resource "aws_route_table" "private-web-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "private-web-rt"
    Terraform = "yes"
  }
}

#associating the public subnet
resource "aws_route_table_association" "rt-asso" {
  subnet_id      = aws_subnet.private-sub.id
  route_table_id = aws_route_table.private-web-rt.id
}

#Creating a security group
resource "aws_security_group" "web-sg" {
  name   = "web-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Creating Application Loadbalancer 
resource "aws_lb" "web-lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = [aws_subnet.public-sub.id, aws_subnet.public-sub1.id]
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.web-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target.arn
  }
}
resource "aws_lb_target_group" "lb-target" {
  name        = "web-lb-target"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}

resource "aws_launch_template" "instance-con" {
  instance_type = "t2.micro"
  image_id      = data.aws_ami.web.id
  #vpc_security_group_ids = [ aws_security_group.web-sg.id ]
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web-sg.id]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y 
sudo systemctl start nginx 
EOF
  )
}

resource "aws_autoscaling_group" "webscalling" {
  #name                = "web-scalling"
  min_size            = 1
  desired_capacity    = 2
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.public-sub.id, aws_subnet.public-sub1.id]
  launch_template {
    id      = aws_launch_template.instance-con.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.lb-target.arn]
}

resource "aws_instance" "web-server" {
  ami                         = data.aws_ami.web.id
  subnet_id                   = aws_subnet.public-sub.id
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.web-sg.id]
  associate_public_ip_address = "true"

  user_data = <<-EOF
  #!/bin/bash 
  sudo apt update -y
  sudo apt install apache2 -y 
  sudo systemctl start apache2 
  EOF

  tags = local.common_tags
}

/*module "instance" {
  source = "../module"
  instance = "t2.micro"
  ami      = data.aws_ami.web.id
  sub      = "subnet-03cb68d25e5198c95"
  key      = "minikube"
  sg       = ["sg-0ed7b0e6d5df0a363"]
}*/