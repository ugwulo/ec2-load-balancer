# Other variables are assigned in the [*.tfvars] file, not tracked by git
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "my aws region"
}

variable "ugwulo_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
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

  default = {
    "80" = {
      description = "HTTP traffic"
      port        = 80
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }

    "443" = {
      description = "HTTPS traffic"
      port        = 443
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }

    "22" = {
      description = "SSH traffic"
      port        = 22
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }
  }

}

variable "ami_id" {
  description = "ami id"
  type        = string
  default     = "ami-00874d747dde814fa"
}

variable "instance_type" {
  description = "Instance type to create an instance"
  type        = string
  default     = "t2.micro"
}


variable "domain_name" {
  type    = string
  default = "ugwulo.me"
}
variable "sub_domain_name" {
  type    = string
  default = "terraform-test"
}

variable "health_check" {
  type = map(string)
  default = {
    "port"     = "80"
    "protocol" = "HTTP"
    "path"     = "/"
    "matcher"  = "200-299"
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