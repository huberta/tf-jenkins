##
resource "aws_db_instance" "default" {
  allocated_storage    = "${var.allocated_storage}"
  engine               = "${var.engine}"
  engine_version       = "${var.engine_version}"
  instance_class       = "${var.instance_class}"
  name                 = "${var.name}"
  username             = "${var.username}"
  password             = "${var.password}"
  db_subnet_group_name = "${var.db_subnet_group_name}"
}