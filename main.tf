provider "aws" {
	region 									= "us-east-1"
	shared_credentials_file = "C:/Users/ShubhamBhatia//.aws/credentials"
	profile 								= "default"
}

resource "aws_ebs_volume" "terra_ebs" {
	availability_zone = "us-east-1a"
	size = 20

	tags {
		Name = "firstEBSvolume"
	}
}

resource "aws_instance" "myfirstec2instance" {
	tags {
		Name 										= "terraform-EC2-1"
		}
		availability_zone 			= "us-east-1a"
		instance_type 					= "t2.micro"
		ami 										= "ami-14c5486b"
		vpc_security_group_ids 	= ["${aws_security_group.terra_sg.id}"]
	}

resource "aws_volume_attachment" "terra_example" {
	device_name 	= "/dev/sdf"
	volume_id 		= "${aws_ebs_volume.terra_ebs.id}"
	instance_id 	= "${aws_instance.myfirstec2instance.id}"

}



resource "aws_cloudwatch_metric_alarm" "terra_alarm"  {
	alarm_name 						= "terraform-CloudWatch"
	comparison_operator 	= "GreaterThanOrEqualToThreshold"
	evaluation_periods 		= "2"
	metric_name 					= "CPUUtilization"
	namespace 						= "AWS/EC2"
	period 								= "60"
	statistic 						= "Average"
	threshold 						= "75"

	alarm_description 		= "This metric will evaluate the EC2 CPU Utilization"
}

resource "aws_security_group" "terra_sg" {
	name = "terraform_security_group"

	egress {
			from_port 		= 0000
			to_port 			= 0000
			protocol 			= "-1"
			cidr_blocks 	= ["0.0.0.0/0"]
		}
	ingress {
			from_port 		= 8080
			to_port 			= 8080
			protocol 			= "tcp"
			cidr_blocks 	= ["0.0.0.0/0"]
		}

	ingress {
			from_port 		= 443
			to_port 			= 443
			protocol 			= "tcp"
			cidr_blocks 	= ["0.0.0.0/0"]
		}

	}


resource "aws_launch_configuration" "terra_lc" {
	 image_id 					= "ami-14c5486b"
	 instance_type 			= "t2.micro"
	 security_groups 		= ["${aws_security_group.terra_sg.id}"]

	}


resource "aws_autoscaling_group" "terra_ASG" {
	launch_configuration 	= "${aws_launch_configuration.terra_lc.id}"
	availability_zones 		= ["${data.aws_availability_zones.terra_az.names}"]
	min_size 							= 2
	max_size 							= 4

#	load_balancers 				= ["${aws_elb.terra_elb.name}"]
#	health_check_type 		= "ELB"
	}

resource "aws_elb" "terra_elb" {
		name 				= "elbterraform"
		availability_zones 	=  ["${data.aws_availability_zones.terra_az.names}"]
		security_groups 		= ["${aws_security_group.terra_sg.id}"]
		listener  {
		lb_port 						= 8080
		lb_protocol 				= "http"
		instance_port 			= "${var.server_port}"
		instance_protocol 	= "http"
		}

		health_check {
			healthy_threshold 	= 2
			unhealthy_threshold = 2
			timeout 						= 3
			interval 						= 10
			target 							=  "HTTP:${var.server_port}/"
		}
	}


resource "aws_s3_bucket" "terra_bucket" {
		bucket 							= "shubhamb0002bucket"
		acl 								= "private"

		tags {
			name 							= "My Sample terraform Bucket"
			Environment 			= "Dev"
		}

		versioning {
		enabled 						= true
		}
	}


data "aws_availability_zones" "terra_az" {}


 module "vpc" {
	source 							= "./vpc"
	public_cidrs 				= ["${var.public_cidrs}"]
	private_cidrs				= ["${var.private_cidrs}"]
	vpc_cidr						= "${var.vpc_cidr}"
	tags {
		Name 							= "hellovpcmoduletag"
		}
	name								= "${var.name}"
	availability_zones	= ["${var.availability_zones}"]
	}




#############################################
#					S3 Bucket 				#
#############################################

resource "aws_s3_bucket" "s3_bucket_full_func"  {

	tags {
		Name 							= "Bucket-with-functionality"
	}

	bucket 							= "bucketfull0002"
	acl 								= "${var.bucket_acl}"
	region 							= "${var.bucket_region}"
	policy 							= "${var.bucket_policy}"
	force_destroy 			= "${var.force_destroy}"

	versioning {
		enabled 					= "${var.versioning_enabled}"
	}

	lifecycle_rule {

		id 								= "bucketfull0002"
		enabled 					= "${var.lifecycle_rule_enabled}"

		prefix 						= "${var.prefix}"
		tags {
			Name 						= "lifecycle management rules"
		}

		noncurrent_version_expiration {
			days 						= "${var.noncurrent_version_expiration_days}"
		}

		noncurrent_version_transition {
			days 						= "${var.noncurrent_version_transition_days}"
			storage_class 	= "GLACIER"
			}

		transition  {
			days 						= "${var.standard_transition_days}"
			storage_class 	= "STANDARD_IA"
		}

		transition {
			days 						= "${var.glacier_transition_days}"
			storage_class 	= "GLACIER"
		}

		expiration {
			days 						= "${var.expiration_days}"
		}

	}

	server_side_encryption_configuration {
		rule {

				apply_server_side_encryption_by_default {

						sse_algorithm 				= "${var.sse_algorithm}"
						kms_master_key_id  		= "${var.key_id}"
				}
			}
		}

	}


resource "aws_cloudwatch_dashboard" "terra_dashboard" {
   dashboard_name = "my-dashboard"
   dashboard_body = <<EOF
 {
   "widgets": [
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "metrics":[
                [
                   "AWS/EC2",
                   "CPUUtilization",
                   "terraform-EC2-1",
                   "i-0a41960920ecd705c"
                ]
             ],
             "period":60,
             "stat":"Average",
             "region":"us-east-1",
             "title":"EC2 Instance CPU"
          }
       },
       {
          "type":"text",
          "x":0,
          "y":7,
          "width":3,
          "height":3,
          "properties":{
             "markdown":"Sample Matrics"
          }
       }
   ]
 }
 EOF
}
