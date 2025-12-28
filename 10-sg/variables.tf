variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "frontend_sg_name" {
  default = "frontend"
}

variable "frontend_sg_description" {
  default = "created sg for frontend instance"
}

variable "bastion_sg_name" {
  default = "bastion"
}

variable "bastion_sg_description" {
  default = "created sg for bastion instance"
}

variable "backend_alb_sg_name" {
  default = "backend-alb"
}

variable "backend_alb_sg_description" {
  default = "created sg for backend-alb"
}

variable "vpn_name" {
  default = "vpn"
}

variable "vpn_description" {
  default = "created sg for roboshop-dev-vpn"
}

variable "redis_name" {
  default = "redis"
}

variable "redis_description" {
  default = "created sg for roboshop-dev-redis"
}

variable "mysql_name" {
  default = "mysql"
}

variable "mysql_description" {
  default = "created sg for roboshop-dev-mysql"
}

variable "mongodb_name" {
  default = "mongodb"
}

variable "mongodb_description" {
  default = "created sg for roboshop-dev-mongodb"
}

variable "rabbitmq_name" {
  default = "rabbitmq"
}

variable "rabbitmq_description" {
  default = "created sg for roboshop-dev-rabbitmq"
}

variable "catalogue_name" {
  default = "catalogue"
}

variable "catalogue_description" {
  default = "created sg for roboshop-dev-catalogue"
}

variable "mongodb_ports_vpn" {
  default = [22, 27017]
}

variable "redis_ports" {
  default = [22, 6379]
}

variable "mysql_ports" {
  default = [22, 3306]
}

variable "rabbitmq_ports" {
  default = [22, 5672]
}