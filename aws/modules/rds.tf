#####Option Group#######
resource "aws_db_option_group" "this" {
  name                     = "${var.environment}-${var.product}-rds"
  option_group_description = "Database option group for ${var.environment}-${var.product}-rds"
  engine_name              = "${var.og_engine_name}"
  major_engine_version     = "${var.major_engine_version}"
  option                   = ["${var.options}"]
  tags {
        Name              = "${var.environment}-${var.product}-rds"
        environment       = "${var.environment}"
        product           = "${var.product}"
        product_component = "db"
   }

  lifecycle {
    create_before_destroy = true
  }
}

#########Parameter Group#########
resource "aws_db_parameter_group" "this" {
  name        = "${var.environment}-${var.product}-rds"
  description = "Database parameter group for ${var.environment}-${var.product}-rds"
  family      = "${var.family}"
  parameter   = ["${var.parameters}"]
  tags {
        Name              = "${var.environment}-${var.product}-rds"
        environment       = "${var.environment}"
        product           = "${var.product}"
        product_component = "$var.db"
   }

  lifecycle {
    create_before_destroy = true
  }
}

########Subnet Group########
resource "aws_db_subnet_group" "this" {
  name        = "${var.environment}-${var.product}-rds"
  description = "Database subnet group for ${var.environment}-${var.product}-rds"
  subnet_ids  = ["${lookup(aws_subnet.this-private-sn.subnet_private_ids, var.db_product_roles1)}","${lookup(aws_subnet.this-private-sn.subnte_private_ids, var.db_product_roles2)}"]
  tags {
        Name              = "${var.environment}-${element(var.product}-rds"
        environment       = "${var.environment}"
        product           = "${var.product}"
        product_component = "db"
   }
}

#####Unique string generator######
resource "random_string" "this_oracle" {
  length = 15
  lower = true
  upper = false
  special = false
  number = false
}

##########RDS Instance Oracle###########
resource "aws_db_instance" "this_oracle" {
  count				  = "${var.oracle_db}"
  identifier                      = "${var.environment)}-${var.product}-rds"
  engine                          = "${var.engine}"
  engine_version                  = "${var.engine_version}"
  instance_class                  = "${var.instance_class}"
  allocated_storage               = "${var.allocated_storage}"
  storage_type                    = "gp2"
  license_model                   = "${var.license_model}"
  name                            = "${var.db_name}"
  username                        = "${var.db_username}"
  password                        = "${random_string.this_oracle.result}"
  port                            = "${var.port}"
  vpc_security_group_ids          = ["${aws_default_security_group.this.id}", "${aws_security_group.this.id}"]
  db_subnet_group_name            = "${aws_db_subnet_group.this.name}"
  parameter_group_name            = "${aws_db_parameter_group.this.name}"
  option_group_name               = "${aws_db_option_group.this.name}"
  multi_az                        = "true"
  monitoring_interval             = "60"
  auto_minor_version_upgrade      = "true"
  apply_immediately               = "true"
  maintenance_window              = "mon:16:00-mon:18:00"
  skip_final_snapshot             = "true"
  backup_retention_period         = "35"
  backup_window                   = "11:00-12:00"
  character_set_name              = "AL32UTF8"      ##This attribute is used only for Oracle instances.
  timezone                        = "${var.timezone}"                            ##This attribute is used only for MSSQL instances.
  timeouts                        = "create"
  deletion_protection             = "true"
  tags {
        Name              = "${var.environment}-${var.product}-rds"
        environment       = "${var.environment}"
        product           = "${var.product}"
        product_component = "db"
   }
}

#####Unique string generator######
resource "random_string" "this_mssql" {
  length = 15
  lower = true
  upper = false
  special = false
  number = false
}

##########RDS Instance MSSQL###########
resource "aws_db_instance" "this_mssql" {
  count				  = "${var.mssql_db}"
  identifier                      = "${var.environment)}-${var.product}-rds"
  engine                          = "${var.engine}"
  engine_version                  = "${var.engine_version}"
  instance_class                  = "${var.instance_class}"
  allocated_storage               = "${var.allocated_storage}"
  storage_type                    = "gp2"
  license_model                   = "${var.license_model}"
  name                            = "${var.db_name}"
  username                        = "${var.db_username}"
  password                        = "${random_string.this_mssql.result}"
  port                            = "${var.port}"
  vpc_security_group_ids          = ["${aws_default_security_group.this.id}", "${aws_security_group.this
.id}"]
  db_subnet_group_name            = "${aws_db_subnet_group.this.name}"
  parameter_group_name            = "${aws_db_parameter_group.this.name}"
  option_group_name               = "${aws_db_option_group.this.name}"
  multi_az                        = "true"
  monitoring_interval             = "60"
  auto_minor_version_upgrade      = "true"
  apply_immediately               = "true"
  maintenance_window              = "mon:16:00-mon:18:00"
  skip_final_snapshot             = "true"
  backup_retention_period         = "35"
  backup_window                   = "11:00-12:00"
  character_set_name              = "AL32UTF8"      ##This attribute is used only for Oracle instances.
  timezone                        = "${var.timezone}"                            ##This attribute is use
d only for MSSQL instances.
  timeouts                        = "create"
  deletion_protection             = "true"
  tags {
        Name              = "${var.environment}-${var.product}-rds"
        environment       = "${var.environment}"
        product           = "${var.product}"
        product_component = "db"
   }
}

##Defining Provider for other accounts to access the R53 zones (in the Corporate Management Acccount).
provider "aws" {
  alias   = "localr53zone"
  region  = "${var.region}"
  profile = "${var.rds_profile_name}"
}

########Route53 Forward Record#########
resource "aws_route53_record" "this_oracle" {
  provider = "aws.localr53zone"
  count    = "${var.oracle_db}"       ####If this count is 0, this resource wont be computed.
  type     = "CNAME"
  ttl      = "300"
  records  = ["${aws_db_instance.this_oracle.address}"]
  zone_id  = "${aws_route53_zone.this.zone_id}"
  name     = "${var.environment}-${var.product}-rds"
}

########Route53 Forward Record#########
resource "aws_route53_record" "this_mssql" {
  provider = "aws.localr53zone"
  count    = "${var.mssql_db}"       ####If this count is 0, this resource wont be computed.
  type     = "CNAME"
  ttl      = "300"
  records  = ["${aws_db_instance.this_mssql.address}"]
  zone_id  = "${aws_route53_zone.this.zone_id}"
  name     = "${var.environment}-${var.product}-rds"
}
