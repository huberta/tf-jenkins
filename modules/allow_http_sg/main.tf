#### Security Groups
### Allow incoming HTTP|HTTPS 
resource "aws_security_group" "allow_http_sg" {
  name = "${var.name}"
  description = "Allow HTTP/HTTPS"

  ### Could probably wrap this into a list
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
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
  value = "${aws_security_group.allow_http_sg.id}"
}