#### Security Groups

### Allow ping and all outgoing traffic
####  All instances will get ngc_default
resource "aws_security_group" "ngc_default_sg" {
  name = "${var.name}"
  description = "Security Group ${var.name}-${var.environment}"

  ### Allow ping
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ### Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
      Name = "${var.name}"
      Environment = "${var.environment}"
  }
}

output "id" {
  value = "${aws_security_group.ngc_default_sg.id}"
}