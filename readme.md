### General Notes
This plan is for testing purposes only.


### Build Notes
Executing "make" will create the plan and attempt to apply the plan to
the system it has been configured for. *** MAKE SURE YOU HAVE THE CURRENT STATE FILE ***

If you do not have the current state file,  this plan will build a duplicate VPC
in AWS. You probably don't want to do that.

```

### This will run the plan.
make

### This will just build the plan and show you what changes will be made
make plan

### This will apply the previous created plan
make apply 

### This will destroy everything
make destroy

```


### Modules
#### vpc_subnets 
- This module builds the VPC itself, configures an Internet gateway, NAT Gateway, subnets, route tables, and associates the subnets appropriately.

#### ngc_default_sg
- This module configures the "NGC Default" security group; which currently allows all ICMP ping traffic in, and all traffic out.  The way the security groups are currently configured this securit group needs to be assigned to any instance that needs to send traffic out.

#### allow_internal_sg
- This module configures the "Allow Internal" security group;  which allows all in-bound traffic from NGC controlled subnets.

#### allow_vpn_sg
 - This module configures the "Allow VPN" security group;  which allows incoming traffic from other VPN instances.

#### bastion_ssh_sg
 - This module configures the "Bastion SSH" security group; which allows incoming traffic only to port 22.

#### efs_dtr
 - Configure EFS and target mounts for Docker Trusted Registry.

```ruby
### mounting notes: command below is single line... ####
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 \
$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-57e5012e.efs.us-east-2.amazonaws.com:/ /mnt/dtr
```

#### ec2_bastion
 - This module configures an ec2 instance for bastion access. Which we use to connect into other instances in the VPC that are protected by private subnet space and security groups that only allow this instance in.

#### ec2_vpn
 - This module configures an ec2 instance with OpenSwan that creates a VPN connection between us-east-1 and us-east-2. You have to update /etc/ipsec.d/ipsec.conf on the us-east-1 side with this instances IP; but everything else should be automagical.

#### ec2_dtr
 - This module configures ec2 instance(s) for use with Docker Trustred Registry.  These three instances will utilize UCP and sit behind ELB


*** See modules for specific notes respectively ***


### Edit the **terraform.tfvars.example** file and rename it to **terraform.tfvars*

```ruby

region          = "us-east-2"
access_key      = "CHANGEIT"
secret_key      = "CHANGEIT"

```