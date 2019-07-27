######Global Variables##########
variable "region" {default = "ap-southeast-2"}
variable "environment" {}
variable "product" {}
variable "purpose" {}

#####AD Variables######
variable "ad_subnet1" {}
variable "ad_subnet2" {}

####Security Group Variables#####
variable "sg_purpose" {}

#####ASG Variables#####
variable "tpl_file_path" {}
variable "tpl_file" {}
variable "elb_count" {}
variable "tg_count" {}
variable "notify_count" {}
variable "root_volume_size" {}
variable "min_size" {}
variable "max_size" {}
variable "desired_capacity" {}
variable "product_roles1" {}
variable "product_roles2" {}
variable "create_lc" {default = true}
variable "create_asg" {default = true}
variable "image_id" {}
variable "instance_type" {}
variable "elb_id" {}

######VPC Variables#####
variable "cidr_block" {}
variable "product_roles" {default = []}

######ACM Variables######
variable "private_key" {}
variable "certificate_body" {}
variable "certificate_chain" {}

#####Load Balancer Variables#####
variable "logging_enabled" {}
variable "alb_count" {}
variable "nlb_count" {}
variable "alb_product_roles1" {}
variable "alb_product_roles2" {}
variable "nlb_product_roles1" {}
variable "nlb_product_roles2" {}
variable "http_listeners_count" {}
variable "http_listeners" {default = []}
variable "http_listeners_forward_rule_count" {}
variable "http_listeners_forward_rule" {default = []}
variable "http_listeners_redirect_rule_count" {}
variable "http_listeners_redirect_rule" {default = []}
variable "https_listeners_count" {}
variable "https_listeners" {default = []}
variable "https_listeners_forward_rule_count" {}
variable "https_listeners_forward_rule" {default = []}
variable "https_listeners_redirect_rule_count" {}
variable "https_listeners_redirect_rule" {default = []}
variable "tcp_listeners_count" {}
variable "tcp_listeners" {default = []}

#####Target Group Variables#####
variable "alb_backend_port" {}
variable "alb_backend_protocol" {}
variable "nlb_backend_port" {}
variable "nlb_backend_protocol" {}
variable "alb_health_check_port" {}
variable "alb_health_check_protocol" {}
variable "nlb_health_check_port" {}
variable "nlb_health_check_protocol" {}

####RDS Variables######
variable "og_engine_name" {}
variable "major_engine_version" {}
variable "options" {default = []}
variable "family" {}
variable "parameters" {default = []}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "port" {}
variable "db_backup_window" {}
variable "max_capacity" {default = []}
variable "min_capacity" {default = []}
variable "db_product_roles1" {}
variable "db_product_roles2" {}
variable "oracle_db" {}
variable "mssql_db" {}
variable "timezone" {}
