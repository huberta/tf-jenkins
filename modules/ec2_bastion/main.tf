data "template_file" "bastion_user_data" {
    template = "${file("user_data/bastion.template")}"

    vars {
       host_name = "${var.name}"
    }
}

### Create our bastion instance(s)
resource "aws_instance" "ec2_bastion" {
    ami = "${var.ami_id}"
    count = "${var.count}"
    vpc_security_group_ids = ["${split(",", var.security_group_id)}"]
    subnet_id = "${element(split(",", var.subnet_id), count.index%2)}"
    instance_type = "t2.micro"
    key_name = "devops.id_rsa"
    associate_public_ip_address = true

    tags {
      Name        = "${var.name}-${var.environment}-${format("%02d", count.index+1)}"
      Environment = "${var.environment}"
    }

    user_data = "${data.template_file.bastion_user_data.rendered}"
}
