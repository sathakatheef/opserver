###### Module Section containig AWS Resources
* Resources can be reused form this section for different environments.
   * Resource/modules created: 
  
    * vpc: vpc, dhcp_option, subnets (private and public), NACLs, IGW, NGW, VGW, Route table Associations, EIP, EIP association (NGW), NGW association (public subnets), default security group
      
    * acm: wildcard certificate (for SSL/TLS redirection through the HTTPS request)
  
    * asg: launch_config, auto_scaling, auto_scaling policies, cloud watch metric (CPU utilization), auto_scaling notification
  
    * sns: sns topics for auto scaling to notify the scaling events depending on which ASG will scale up or down.
  
    * load_balancer: either creates alb or nlb based on the requirements. Also creates either http listener, hhtps listener, http forward listener rule, https forward listener rule
  
    * target_group: target groups of instance type for the ALB, it also creates NLB depending on the environment.  
  
    * iam_role: iam roles for the EC2 instances from the ASG which gives basic read permission and permission for auto domain join.
  
    * key_pair: Creates new EC2 key_pair based on the public key passed in which is created through the tls_private_key module.
 
    * rds: The module creates either MSSQL or Oracle database based on the environment.
 
    * security_group: creates a standard security group that allows only private IPs.   

    * ad: Creates AWS Active directory service (this is mainly for auto joining the EC2 instances to the domain).

    * r53: Creates a public hosted zone which will have DNS of the website.

    * ssm_doc: Creates a SSM Document which will be used to auto join the domain for the EC2 instances.    
* __variables.tf__ file will have all the variables defined that are required for the resources.
* __outputs.tf__ file will have all the outputs defined depending on the environment requirements.
