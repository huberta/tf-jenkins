### Setting up the VPC
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = "${var.enable_dns_support}"
  enable_dns_hostnames  = "${var.enable_dns_hostnames}"

  tags {
    Name = "${var.name}-${var.environment}-vpc"
    Environment = "${var.environment}"
    Team = "${var.team}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.name}-${var.environment}-igw"
  }
}

resource "aws_customer_gateway" "cgw" {
  bgp_asn = "${var.bgp_asn}"
  ip_address = "${var.cgw_ip}"
  type = "${var.cgw_type}"
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.name}-${var.environment}-vpn"
  }
}

resource "aws_vpn_connection" "main" {
    vpn_gateway_id = "${aws_vpn_gateway.vpn_gw.id}"
    customer_gateway_id = "${aws_customer_gateway.cgw.id}"
    type = "ipsec.1"
    static_routes_only = true

  tags {
    Name = "${var.name}-${var.environment}-vpn"
  }
}

resource "aws_vpn_connection_route" "ngc_routes" {
  count = "${length(split(",", var.ngc_routes))}"
  destination_cidr_block = "${element(split(",", var.ngc_routes), count.index)}"
  vpn_connection_id = "${aws_vpn_connection.main.id}"
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${length(split(",", var.public_subnets_cidr))}"
  cidr_block = "${element(split(",", var.public_subnets_cidr), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags {
    Name = "${var.name}-${var.environment}-public-${element(split(",", var.azs), count.index)}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  lifecycle {
    ignore_changes = ["*"]
  }

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(split(",", var.public_subnets_cidr))}"
  subnet_id  = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

### can we do this for the vgw?
resource "aws_route" "ngc_public" {
  count = "${length(split(",", var.ngc_routes))}"
  destination_cidr_block  = "${element(split(",", var.ngc_routes), count.index)}"
  route_table_id = "${aws_route_table.public.id}"
  gateway_id = "${aws_vpn_gateway.vpn_gw.id}"
}

output "public_subnets_id" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

### NAT
resource "aws_eip" "nat" {
    vpc = true
}

# Stand up NAT
resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${element(aws_subnet.public.*.id, 1)}"
    depends_on = ["aws_internet_gateway.igw"]
}


### Create the Private Subnets
resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(split(",", var.private_subnets_cidr))}"
  cidr_block              = "${element(split(",", var.private_subnets_cidr), count.index)}"
  availability_zone       = "${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.name}-${var.environment}-private-${element(split(",", var.azs), count.index)}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

  lifecycle {
    ignore_changes = ["*"]
  }

  tags {
    Name = "${var.name}-private"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.private_subnets_cidr))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

### can we do this for the vgw?
resource "aws_route" "ngc_private" {
  count = "${length(split(",", var.ngc_routes))}"
  destination_cidr_block  = "${element(split(",", var.ngc_routes), count.index)}"
  route_table_id = "${aws_route_table.private.id}"
  gateway_id = "${aws_vpn_gateway.vpn_gw.id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "private_subnets_id" {
  value = "${join(",", aws_subnet.private.*.id)}"
}
