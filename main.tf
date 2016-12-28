provider "aws" {
  region                   = "us-west-2"
  shared_credentials_file  = "/var/lib/jenkins/.aws/credentials"
}

### Define our EC2 instances here
module "ec2_bastion" {
  source = "modules/ec2_bastion"
  vpc_id = "vpc-fb01ce92"
  name      = "mybastion"
  environment = "test"
  subnet_id = "subnet-cfdd35b4"
  security_group_id = "sg-721dba1b"
  instance_type = "t2.micro"
  ami_id = "ami-5ec1673e"
}