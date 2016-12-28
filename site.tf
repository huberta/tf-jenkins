provider "aws" {
  region        = "us-west-2"
  shared_credentials_file  = "/var/lib/jenkins/.aws/credentials"
  // shared_credentials_file  = "/Users/robert.hough/.aws/credentials"
}

### Set up our backend state file
data "terraform_remote_state" "ngc_us-west-2" {
  backend = "s3"
  config {
    bucket = "ngc-devops"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

### Define the base VPC, Subnets, Gateways and Route Tables
module "vpc_subnets" {
  source              = "modules/vpc_subnets"
  name                = "auw2inf"
  team                = "DevOps"
  environment         = "production"
  enable_dns_support  = "true"
  enable_dns_hostnames  = "true"
  vpc_cidr              = "172.16.96.0/21"
  public_subnets_cidr   = "172.16.96.0/25,172.16.96.128/25,172.16.97.0/25"
  private_subnets_cidr  = "172.16.98.0/25,172.16.98.128/25,172.16.99.0/25"
  ngc_routes  = "172.17.0.0/16,172.18.0.0/16,172.27.0.0/16,172.28.0.0/16,172.31.0.0/16,192.168.1.0/24,192.168.2.0/24,192.168.4.0/24,192.168.5.0/24,192.168.11.0/24,192.168.250.0/24,192.168.252.0/24,192.168.253.0/24"
  azs                   = "us-west-2a,us-west-2b,us-west-2c"
  bgp_asn               = "65000"
  cgw_ip                = "216.37.14.250"
  cgw_type                  = "ipsec.1"
}

### Define our security groups here
module "ngc_default_sg" {
  source    = "modules/ngc_default_sg"
  vpc_id = "${module.vpc_subnets.vpc_id}"
  name      = "ngc_default_sg"
  environment = "production"
}

module "bastion_ssh_sg" {
  source    = "modules/bastion_ssh_sg"
  vpc_id = "${module.vpc_subnets.vpc_id}"
  name      = "bastion_ssh_sg"
  environment = "production"
}

module "allow_vpn_sg" {
  source    = "modules/allow_vpn_sg"
  vpc_id = "${module.vpc_subnets.vpc_id}"
  name      = "allow_vpn_sg"
  environment = "production"
}

module "allow_internal_sg" {
  source    = "modules/allow_internal_sg"
  vpc_id = "${module.vpc_subnets.vpc_id}"
  name      = "allow_internal_sg"
  environment = "production"
  source_cidr_block = "172.16.0.0/12"
}

module "allow_http_sg" {
  source    = "modules/allow_http_sg"
  vpc_id = "${module.vpc_subnets.vpc_id}"
  name      = "allow_http_sg"
  environment = "production"
}

### Define our EC2 instances here
module "ec2_bastion" {
  source = "modules/ec2_bastion"
  vpc_id = "${module.vpc_subnets.vpc_id}"
  name      = "auw2bastion"
  environment = "production"
  count = "1"
  subnet_id = "${module.vpc_subnets.public_subnets_id}"
  security_group_id = "${module.ngc_default_sg.id},${module.allow_internal_sg.id},${module.bastion_ssh_sg.id}"
  instance_type = "t2.micro"
  ami_id = "ami-5ec1673e"
}

### Define our EC2 instances here
module "ec2_vpn" {
  source = "modules/ec2_vpn"
  vpc_id = "${module.vpc_subnets.vpc_id}"
  name      = "auw2vpn"
  environment = "production"
  count = "1"
  subnet_id = "${module.vpc_subnets.public_subnets_id}"
  source_dest_check = "false"
  security_group_id = "${module.ngc_default_sg.id},${module.allow_vpn_sg.id},${module.allow_internal_sg.id}"
  instance_type = "t2.micro"
  ami_id = "ami-5ec1673e"
  userdata = "vpn.template"
}
