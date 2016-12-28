### Allow all of our subnets to talk to one another
resource "aws_security_group" "allow_internal_sg" {
  name = "${var.name}"
  description = "Only all connectivity from 172.16.0.0/12"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.source_cidr_block}"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
      Name = "${var.name}"
      Environment = "${var.environment}"
  }
}

output "id" {
  value = "${aws_security_group.allow_internal_sg.id}"
}