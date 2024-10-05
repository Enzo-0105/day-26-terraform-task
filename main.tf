provider "aws" {
  region = "us-east-1"
}
module "vpcs" {
  source = "./modules/vpc"
  env    = "prod"
}

module "lb" {
  source = "./modules/load-balancer"

  vpc    = module.vpcs.vpc_id
  subnet = module.vpcs.subnet_id
  sg     = module.vpcs.sg_id
}

module "EC2" {
  source = "./modules/ec2"

  sg = module.vpcs.sg_id
}
module "aws_autoscaling_group" {
  source = "./modules/auto-scaling"

  target_group    = [module.lb.target_group_arn]
  subnets         = [module.vpcs.subnet_id]
  launch_template = module.EC2.template
}

