data "template_file" "user_data" {
    template = "${file("user_data/${var.userdata}")}"

    vars {
       host_name = "${var.name}"
    }
}

### Create our instance(s)
resource "aws_instance" "host" {
    ami = "${var.ami_id}"
    subnet_id = "${element(split(",", var.subnet_id), count.index)}"
    vpc_security_group_ids = ["${split(",", var.security_group_id)}"]
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    associate_public_ip_address = true
    disable_api_termination = "${var.disable_api_termination}"
    monitoring = "${var.monitoring}"

    lifecycle {
        ignore_changes = ["user_data"]
    }

    root_block_device {
        volume_type = "standard"
        volume_size = 40
    }

    ebs_block_device {
        device_name = "/dev/sdf"
       	volume_size = 100
        volume_type = "gp2"
        delete_on_termination = true
    }

    ebs_optimized = "${var.ebs_optimized}"

    tags {
      Name        = "${var.name}-${var.environment}-${format("%02d", count.index+1)}"
      Environment = "${var.environment}"
    }

    user_data = "${data.template_file.user_data.rendered}"

    count = "${var.count}"
}
