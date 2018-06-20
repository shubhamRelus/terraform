variable "name" {
	type        = "string"
	default 		= "tfsamplecheck"
	}

variable "public_cidrs" {
	type        = "list"
	default 		= ["10.0.1.0/24"]
	}

variable "private_cidrs" {
	type        = "list"
	default 		= ["10.0.2.0/24"]
	}

variable "vpc_cidr" {

	default			= "10.0.0.0/16"
	}

variable "availability_zones" {
	type        = "list"
	default 		= ["us-east-1a", "us-east-1b", "us-east-1c"]
	}

variable server_port {
	description = "the port used by server"
	default 		= 8080
	}


#############################################
#				S3 Bucket variables			#
#############################################

#variable "bucket_name"  {
#	default = "terraform.Bucket.Full.Functionality"
#}

variable "bucket_acl"  {
	default = "log-delivery-write"
}

variable "bucket_region"  {
	default = "us-east-1"
}

variable "bucket_policy"  {
	default = ""
}

variable "force_destroy"  {
	default = "false"
}

variable "versioning_enabled"  {
	default = "true"
}

variable "lifecycle_rule_enabled"  {
	default = "true"
}

variable "prefix"  {
	default = ""
}

variable "noncurrent_version_expiration_days"  {
	default = "60"
}

variable "noncurrent_version_transition_days"  {
	default = "30"
}

variable "standard_transition_days"  {
	default = "30"
}

variable "glacier_transition_days"  {
	default = "60"
}

variable "expiration_days"  {
	default = "90"
}

variable "sse_algorithm"  {
	default = "AES256"
}

variable "key_id"  {
	default = ""
}
