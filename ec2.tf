resource "aws_instance" "ubuntu" {
  count           = length(aws_subnet.public_subnets.*.id)
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.public_subnets.*.id, count.index)
  associate_public_ip_address = true
  security_groups = [aws_security_group.igw_sg.id, ]
  key_name        = "ec2-user"
  # iam_instance_profile = data.aws_iam_role.iam_role.name

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ~/Ansible/inventory"
  }

  tags = {
    "Name"      = "Server-${count.index}"
    "CreatedBy" = "Terraform"
  }
}
