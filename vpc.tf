# ---------resources and modules for VPC - start - ----------------

module "vpc" {
	source 								= "terraform-aws-modules/vpc/aws"
	version 							= "1.9.1"

	name 									= "${var.name}"
	cidr 									= "${var.vpc_cidr}"

	azs 									= ["${var.availability_zones}"]
	public_subnets 				= ["${var.public_cidrs}"]
	private_subnets 			= ["${var.private_cidrs}"]

	tags = ["${var.tags}"]

#	enable_nat_gateway 	= true
	enable_vpn_gateway 		= true
}


resource "aws_security_group" "public" {
		vpc_id 							= "${module.vpc.vpc_id}"
		description 				= "${var.name} Public"
		name_prefix 				= "${var.name}-pub-"

		ingress {
			from_port 				= 8080
			to_port 					= 8080
			protocol 					= "tcp"
			cidr_blocks 			= ["0.0.0.0/0"]
		}

		ingress {
			from_port 				= 443
			to_port 					= 443
			protocol 					= "tcp"
			cidr_blocks 			= ["0.0.0.0/0"]
		}

		egress {
			from_port 				= 0
			to_port 					= 0
			protocol 					= -1
			cidr_blocks 			= ["0.0.0.0/0"]
		}
	}


resource "aws_security_group" "private" {
	vpc_id 								= "${module.vpc.vpc_id}"
	description 					= "${var.name} Private"
	name_prefix 					= "${var.name}-pri-"

	ingress {
		from_port 					= 8080
		to_port 						= 8080
		protocol 						= "tcp"
		security_groups 		= ["${aws_security_group.public.id}"]
	}

	ingress {
		from_port 					= 443
		to_port 						= 443
		protocol 						= "tcp"
		security_groups 		= ["${aws_security_group.public.id}"]
	}

	egress {
		from_port 					= 0
		to_port 						= 0
		protocol 						= -1
		cidr_blocks 				= ["0.0.0.0/0"]
	}
}


# ---------output for VPC created - start - ----------------

output "public subnet"  {
	value 								= ["${module.vpc.public_subnets}"]
}

output "private subnet"  {
	value 								= ["${module.vpc.private_subnets}"]
}

output "public security group id"   {
	value 								= "${aws_security_group.public.description}"
 }

output "private security group id"   {
	value 								= "${aws_security_group.private.description}"
}
# ---------output for VPC created - end - ----------------



# ---------variables defined for VPC - start- ---------------

variable "name" {
	type        				= "string"
	default 						= "vpcterra"
	description 				= "this will provides the name of VPC"

	}

variable "public_cidrs" {
	type        				= "list"
	default 						= ["10.0.1.0/24"]
	description 				= "CIDR address for public subnet!"
	}

variable "private_cidrs" {
	type        				= "list"
	default 						= ["10.0.2.0/24"]
	description 				= "CIDR address for private subnet!"
	}

variable "availability_zones" {
	type        				= "list"
	default 						= ["us-east-1a"]
	description 				= "CIDR address for public subnet!"
	}

variable "tags" {
	type 								= "map"
	description 				= "This will provides the mapping of tags variables"
	}

variable "vpc_cidr" {
	type        				= "string"
	default 						= "10.0.0.0/16"
	description 				= "This will provide the range of VPC addresses"
	}
# ---------variables defined for VPC - end - ---------------
	
