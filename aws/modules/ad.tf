#####Unique string generator######
resource "random_string" "this" {
  length = 15
  lower = true
  upper = false
  special = false
  number = false
}

resource "aws_directory_service_directory" "this" {
  name     = "${aws_rout53_zone.this.zone_id}"
  password = "${random_string.this.result}"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = "${aws_vpc.this.id}"
    subnet_ids = ["${lookup("${aws_subnet.this-private-sn.subnet_private_ids}","${var.ad_subnet1}")}", "${lookup("${aws_subnet.this-private-sn.subnet_private_ids}","${var.ad_subnet2}")}"]
  }
}
