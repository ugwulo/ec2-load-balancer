#create a security group 
resource "aws_security_group" "igw_sg" {
  name        = "igw-sg"
  description = "Allow ssh & HTTP/S inbound traffic"
  vpc_id      = aws_vpc.ugwulo_vpc.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Internet-gateway-sg"
  }
}