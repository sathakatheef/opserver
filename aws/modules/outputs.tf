#############VPC Outputs#######
output "vpc_id" {
  value = "${aws_vpc.this.id}"
}

output "subnet_private_ids" {
  value = "${
   map(
      "web-a","${element(concat(aws_subnet.this-private-sn.*.id,list("")), 0)}"
      "deploy-b","${element(concat(aws_subnet.this-private-sn.*.id,list("")), 3)}"
      "db-a","${element(concat(aws_subnet.this-private-sn.*.id,list("")), 4)}"
      "web-b","${element(concat(aws_subnet.this-private-sn.*.id,list("")), 1)}"
      "deply-a","${element(concat(aws_subnet.this-private-sn.*.id,list("")), 2)}"
      "db-b","${element(concat(aws_subnet.this-private-sn.*.id,list("")), 5)}"
     )}"
}

output "subnet_public_ids" {
  value = "${
   map(
    "pub-a", "${element(concat(aws_subnet.this-pub-sn.*.id,list("")), 0)}",
    "pub-b", "${element(concat(aws_subnet.this-pub-sn.*.id,list("")), 1)}",
     )
     }"
}

output "subnet_id_db-a" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 0)}"
}

output "subnet_id_deployment-b" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 1)}"
}

output "subnet_id_services-a" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 2)}"
}

output "subnet_id_utility-b" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 3)}"
}

output "subnet_id_miscellaneous-a" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 4)}"
}

output "subnet_id_db-b" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 5)}"
}

output "subnet_id_deployment-a" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 6)}"
}

output "subnet_id_services-b" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 7)}"
}

output "subnet_id_utility-a" {
   value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 8)}"
}

output "subnet_id_miscellaneous-b" {
  value = "${element(concat(aws_subnet.this-private-sn.*.id,list("")), 9)}"
}

output "subnet_id_pub-a" {
  value = "${element(concat(aws_subnet.this-pub-sn.*.id,list("")), 0)}"
}

output "subnet_id_pub-b" {
  value = "${element(concat(aws_subnet.this-pub-sn.*.id,list("")), 1)}"
}

output "security_group_id" {
  value = "${aws_security_group_id.this.id}"
}

output "sg-default-id" {
  value = "${aws_default_security_group.this.id}"
}

######Route53 Zone ID OUTPUTS#######
output "aws_route53_zone_id" {
  value = "${aws_rout53_zone.this.zone_id}"
}

output "rds_arn" {
  value = "${aws_rds_cluster.aurora.endpoint}"
}

######AD OUTPUTS#########3
output "ad_id" {
  value = "${aws_directory_service_directory.this.id}"
}

output "access_url" {
  value = "${aws_directory_service_directory.this.access_url}"
}

output "dns_ip_addresses" {
  value = "${aws_directory_service_directory.this.dns_ip_addresses}"
}

output "dns_ip_address_1" {
  value = "${element(concat(aws_directory_service_directory.this.dns_ip_addresses,list("")), 0)}"
}

output "dns_ip_address_2" {
  value = "${element(concat(aws_directory_service_directory.this.dns_ip_addresses,list("")), 1)}"
}

output "security_group_id" {
  value = "${aws_directory_service_directory.this.security_group_id}"
}

####KEY PAIR OUTPUT#######3
output "key_name" {
  value = "${aws_key_pair.this.key_name}"
}
