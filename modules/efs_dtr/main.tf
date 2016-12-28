resource "aws_efs_file_system" "dtr_efs" {
  performance_mode = "maxIO"
  tags {
    Name = "dtr_efs"
  }
}

resource "aws_efs_mount_target" "dtr_efs" {
  count = 3
  file_system_id = "${aws_efs_file_system.dtr_efs.id}"
  subnet_id = "${element(split(",", var.subnet_id), count.index)}"
  security_groups = ["${split(",", var.security_group_id)}"]
}