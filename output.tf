output "public_ip_ec2" {
	value = "${aws_instance.myfirstec2instance.public_ip}"
	}
	
output "elb_dns_name" {
	value = "${aws_elb.terra_elb.dns_name}"
	}
	
output "ebs_id" {
	value = "${aws_ebs_volume.terra_ebs.id}"
	}	
	
#############################################
#				S3 Bucket variables			#
#############################################

#output "bucket_name"	{
#	value = "${aws_s3_bucket.s3_bucket_full_func.bucket_name}"
#}

output "bucket_acl"	{
	
	value = "${aws_s3_bucket.s3_bucket_full_func.acl}"
}

output "bucket_region:"	{
	
	value = "${aws_s3_bucket.s3_bucket_full_func.region}"
}

output "bucket_arn:"	{
	
	value = "${aws_s3_bucket.s3_bucket_full_func.arn}"
}

#output "bucket_versioning:"	{
#	
#	value = "${aws_s3_bucket.s3_bucket_full_func.versioning.enabled}"
#}
