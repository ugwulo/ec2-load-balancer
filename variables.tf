variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "my aws region"
}

variable "ugwulo_vpc_cidr" {
  type = string
}

variable "igw_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_tenancy" {
  type        = string
  default     = "default"
  description = "this defines the tenancy of a VPC. Whether it is default or dedicated"
}

variable "ingress_rules" {
  type = map(object({
    description = string
    port        = number
    protocol    = string
    cidr        = list(string)
  }))

}

variable "ami_id" {
  description = "ami id"
  type        = string
}

variable "instance_type" {
  description = "Instance type to create an instance"
  type        = string
  default     = "t2.micro"
}


variable "domain_name" {
  type = string
}
variable "sub_domain_name" {
  type = string
}

# variable "Application_LB_DNS" {
#   default = aws_lb.lb.dns_name
# }
variable "zone_id" {
  type        = string
  description = "route53 hosted zone ID"
}

variable "health_check" {
  type = map(string)
  default = {
    "interval"            = "300"
    "path"                = "/"
    "timeout"             = "60"
    "matcher"             = "200"
    "healthy_threshold"   = "5"
    "unhealthy_threshold" = "5"
  }
}

variable "ssh_key" {
  description = "SSH Key"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH private Key name"
  type        = string
}