data "template_file" "user_data" {
    template = "${file("user_data/${var.userdata}")}"

    vars {
       host_name = "${var.name}"
    }
}

### Create our instance(s)
resource "aws_instance" "host" {
    ami = "${var.ami_id}"
    count = "${var.count}"
    subnet_id = "${element(split(",", var.subnet_id), count.index%2)}"
    vpc_security_group_ids = ["${split(",", var.security_group_id)}"]
    instance_type = "t2.micro"
    key_name = "devops.id_rsa"
    associate_public_ip_address = true
    source_dest_check = "${var.source_dest_check}"

    tags {
      Name        = "${var.name}-${var.environment}-${format("%02d", count.index+1)}"
      Environment = "${var.environment}"
    }

    user_data = "${data.template_file.user_data.rendered}"
}

### Assign public ip to our vpn
resource "aws_eip" "eip" {
    instance = "${aws_instance.host.id}"
    vpc = true
}
