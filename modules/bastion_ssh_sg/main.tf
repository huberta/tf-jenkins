#### Security Groups
### Allow incoming SSH to our bastions
resource "aws_security_group" "bastion_ssh_sg" {
  name = "${var.name}"
  description = "Allow ssh to bastion hosts for each vpc from anywhere"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
      Name = "${var.name}"
      Environment = "${var.environment}"
  }
}

output "id" {
  value = "${aws_security_group.bastion_ssh_sg.id}"
}