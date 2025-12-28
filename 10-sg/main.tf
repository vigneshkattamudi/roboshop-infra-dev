module "frontend" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id         = local.vpc_id
}

module "bastion" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  environment = var.environment
  project     = var.project

  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = local.vpc_id
}

module "backend_alb" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  environment = var.environment
  project     = var.project

  sg_name        = var.backend_alb_sg_name
  sg_description = var.backend_alb_sg_description
  vpc_id         = local.vpc_id
}

module "vpn" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  environment = var.environment
  project     = var.project

  sg_name        = var.vpn_name
  sg_description = var.vpn_description
  vpc_id         = local.vpc_id
}

module "mongodb" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  environment = var.environment
  project     = var.project

  sg_name        = var.mongodb_name
  sg_description = var.mongodb_description
  vpc_id         = local.vpc_id
}

module "redis" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  environment = var.environment
  project     = var.project

  sg_name        = var.redis_name
  sg_description = var.redis_description
  vpc_id         = local.vpc_id
}

module "mysql" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  environment = var.environment
  project     = var.project

  sg_name        = var.mysql_name
  sg_description = var.mysql_description
  vpc_id         = local.vpc_id
}

module "rabbitmq" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  environment = var.environment
  project     = var.project

  sg_name        = var.rabbitmq_name
  sg_description = var.rabbitmq_description
  vpc_id         = local.vpc_id
}

module "catalogue" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/vigneshkattamudi/terraform-aws-securitygroup.git?ref=main"
  environment = var.environment
  project     = var.project

  sg_name        = var.catalogue_name
  sg_description = var.catalogue_description
  vpc_id         = local.vpc_id
}



# backend ALB accepting connections from my bastion host on port no 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

#VPN ports 22, 443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
#Mongodb
resource "aws_security_group_rule" "mongodb_vpn" {
  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_bastion" {
  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "redis" {
  type                     = "ingress"
  count                    = length(var.redis_ports)
  from_port                = var.redis_ports[count.index]
  to_port                  = var.redis_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.redis.sg_id
}

resource "aws_security_group_rule" "mysql" {
  type                     = "ingress"
  count                    = length(var.mysql_ports)
  from_port                = var.mysql_ports[count.index]
  to_port                  = var.mysql_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mysql.sg_id
}

resource "aws_security_group_rule" "rabbitmq" {
  type                     = "ingress"
  count                    = length(var.rabbitmq_ports)
  from_port                = var.rabbitmq_ports[count.index]
  to_port                  = var.rabbitmq_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.rabbitmq.sg_id
}
#Catalogue
resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.catalogue.sg_id
}