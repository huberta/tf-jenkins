### Allow all of our subnets to talk to one another
### Allow VPN boxes to talk back and forth
resource "aws_security_group" "allow_vpn" {
  name = "${var.name}"
  description = "Only all connectivity from VPN instances"

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
  value = "${aws_security_group.allow_vpn.id}"
}