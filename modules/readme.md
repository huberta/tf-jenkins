### Modules
#### vpc_subnets 
- This module builds the VPC itself, configures an Internet gateway, NAT Gateway, subnets, route tables, and associates the subnets appropriately.

#### ngc_default_sg
- This module configures the "NGC Default" security group; which currently allows all ICMP ping traffic in, and all traffic out.  The way the security groups are currently configured this securit group needs to be assigned to any instance that needs to send traffic out.

#### allow_internal_sg
- This module configures the "Allow Internal" security group;  which allows all in-bound traffic from NGC controlled subnets.

#### allow_http_sg
- Allow incoming http/https connections

#### allow_vpn_sg
- This module configures the "Allow VPN" security group;  which allows incoming traffic from other VPN instances.

#### bastion_ssh_sg
- This module configures the "Bastion SSH" security group; which allows incoming traffic only to port 22.

#### efs_dtr
- Configure EFS for use with DTR

#### ec2_bastion
- This module configures an ec2 instance for bastion access. Which we use to connect into other instances in the VPC that are protected by private subnet space and security groups that only allow this instance in.

#### ec2_vpn
- This module configures an ec2 instance with OpenSwan that creates a VPN connection between us-east-1 and us-east-2. You have to update /etc/ipsec.d/aue1-aue2.conf on the us-east-1 side with this instances IP; but everything else should be automagical.

#### ec2_dtr
- This module configures ec2 instances for use in the DTR cluster.

#### rds_tmsdev
- This module creates an RDS instance called "tmsdev".  This is a test instance and can be removed at any time.