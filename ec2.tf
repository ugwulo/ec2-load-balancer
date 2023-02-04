resource "aws_instance" "ubuntu" {
  count                       = length(aws_subnet.public_subnets.*.id)
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(aws_subnet.public_subnets.*.id, count.index)
  associate_public_ip_address = true
  security_groups             = [aws_security_group.igw_sg.id, ]
  key_name                    = "ubuntu"

  # push public IPs to the inventory file
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ~/Ansible/host-inventory"
  }

  tags = {
    "Name"      = "Server-${count.index + 1}"
    "CreatedBy" = "Terraform"
  }
}

# Execute ansible playbook
resource "null_resource" "ansible-playbook" {
  provisioner "local-exec" {
    # with AWS CLI installed in my local machine, I didn't need to pass the private ssh key path, I just put it for clarity
    # my default host inventory config file points to ~/Ansible/host-inventory
    command = "ansible-playbook --private-key ~/.ssh/id_rsa ~/Ansible/main.yml"
  }

  depends_on = [aws_instance.ubuntu]
}
