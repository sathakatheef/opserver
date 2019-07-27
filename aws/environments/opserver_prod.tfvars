#####Global Variables######
    account_name = "teg-test"
    environment  = "prod"
    product      = "opserver"
    purpose      = "web"

######AD Variables########
    ad_subnet1 = "utility-a"
    ad_subnet2 = "utility-b"

#######Security Group Variables#####
    sg_purpose = "standard"

######VPC Variables########
    product_roles = ["web","utility","db"]
    cidr_block    = "10.26.0.0/16"

#####ACM Variables#####
    cert_body       = "../../../../certs/cert-body.pem"
    cert_privatekey = "../../../../certs/cert-key.pem"
    cert_chain      = "../../../../certs/cert-chain.pem"

#####ASG Variables######
   tpl_file           = "user_data"
   tpl_filepath       = "user_data.ps1"
   elb_count          = "0"
   tg_count           = "1"
   notify_count       = "1"
   root_volume_size   = "70"
   min_size           = "2"
   max_size           = "4"
   desired_capacity   = "2"
   product_roles1     = "web-a"
   product_roles2     = "web-b"
   create_lc 	      = "1"
   create_asg 	      = "1"
#  image_id 	      = "ami-007b86205b0b5794c"    ####Microsoft Windows Server 2012 Base
   instance_type      = "r4.large"

####Load Balancer Variables######
    logging_enabled			= "false"
    alb_count 				= "1"
    nlb_count 				= "0"
    alb_product_roles1                  = "pub-a"
    alb_product_roles2                  = "pub-b"
    http_listeners_count 		= "1"
    http_listeners_forward_rule_count   = "0"
    http_listeners_redirect_rule_count  = "0"
    https_listeners_count 		= "1"
    https_listeners_forward_rule_count  = "1"
    https_listeners_redirect_rule_count = "0"
    tcp_listeners_count                 = "0"

#####Target Group Variables#####
    alb_backend_port          = "80"
    alb_backend_protocol      = "http"
    alb_health_check_port     = "80"
    alb_health_check_protocol = "http"

#####RDS Variables######
   oracle_db		= "1"
   mssql_db		= "0"
   og_engine_name       = "oracle-se2"
   major_engine_version = "12.1"
   family		= "oracle-se2-12.1"
   engine		= "oracle-se2"
   engine_version	= "12.1.0.2.v14"
   instance_class	= "db.m4.xlarge"
   db_name		= "ORCL"
   db_username		= "admin"
   port			= "1521"
   db_product_roles1 	= "db-a"
   db_product_roles2 	= "db-b"
