###Check for User Data
data "template_file" "user_data" {
###If the user data file is empty, user_data wont be computed, otherwise user data will be computed. An empty file must be specified for this logic to work (even if user data is not to be computed)
    template = "${var.tpl_file == "" ? var.tpl_file : file("${var.tpl_file_path}")}"
}

#####Get Account ID#######
data "aws_caller_identity" "ami" {}

#####Get Windows 2012 R2 Base AMI#####
data "aws_ami" "windows_2012" {
  most_recent = true
  owners      = ["${data.aws_caller_identity.ami.account_id}"] # Canonical

  filter {
    name   = "name"
    values = ["Microsoft Windows Server 2012 R2 Base"]
  }
}

################## Launch configuration  ###################
resource "aws_launch_configuration" "this" {
  count                       = "${var.create_lc}"       ##This is set to true by default.
  name_prefix                 = "${var.environment == "prod" ? prod-${var.product}-${var.purpose}-lc : ${var.environemnt}-${var.product}-${var.purpose}-lc"
  image_id                    = "${var.image_id == "" ? data.aws_ami.windows_2012 : var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_role.this.name}"
  key_name                    = "${aws_key_pair.this.key_name}"
  security_groups             = ["${aws_default_security_group.this.id}", "${aws_security_group.this.id}"]
  associate_public_ip_address = "false"
  user_data                   = "${data.template_file.user_data.rendered}"
  enable_monitoring           = "true"
  placement_tenancy           = "default"
  ebs_optimized               = "false"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.root_volume_size}"
    delete_on_termination = "true" 
  }

  lifecycle {
    create_before_destroy = true
  }
}


################## Autoscaling group #################
resource "aws_autoscaling_group" "this" {
  count                     = "${var.create_asg ? 1 : 0}"      ###This is set to 1 by default. So the count value will always be 1.
  name                      = "${var.environment == "prod" ? prod-${var.product}-${var.purpose}-asg : ${var.environment}-${var.product}-${var.purpose}-asg"
  launch_configuration      = "${var.create_lc ? element(aws_launch_configuration.this.*.name, 0) : var.launch_configuration}"
  vpc_zone_identifier       = ["${lookup(aws_subnet.this-private-sn.subnet_private_ids, var.product_roles1)}","${lookup(aws_subnet.this-private-sn.subnet_private_ids, var.product_roles2)}"]   ######Private subnets
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  desired_capacity          = "${var.desired_capacity}"
  health_check_grace_period = "300"
  health_check_type         = "ELB"
  min_elb_capacity          = "0"
  wait_for_elb_capacity     = "false"
  default_cooldown          = "300" 
  force_delete              = "false" 
  termination_policies      = ["Default"]
  enabled_metrics           = [
                "GroupMinSize",
                "GroupMaxSize",
                "GroupDesiredCapacity",
                "GroupInServiceInstances",
                "GroupPendingInstances",
                "GroupStandbyInstances",
                "GroupTerminatingInstances",
                "GroupTotalInstances",
                              ]
  metrics_granularity       = "1Minute"
  wait_for_capacity_timeout = "0"
  protect_from_scale_in     = "false"

tags = [
    {
      key                 = "Name"
      value               = "${var.environment == "prod" ? prod-${var.product}-${var.purpose} : ${var.enviroment}-${var.product}-${var.purpose}"
      propagate_at_launch = true
    },
    {
      key                 = "NamePrefix"
      value               = "${var.environment == "prod" ? prod-${var.product} : ${var.environment}-${var.product}"
      propagate_at_launch = true
    },
    {
      key                 = "environment"
      value               = "${var.environment == "prod" ? "prod" : ${var.environment}}"
      propagate_at_launch = true
    },
    {
      key                 = "product"
      value               = "${var.product}"
      propagate_at_launch = true
    },
    {
      key                 = "purpose"
      value               = "${var.purpose}"
      propagate_at_launch = true
    },
  ]

  lifecycle {
      create_before_destroy = true
  }
}

#######auto Scaling ELB Attachment###########
resource "aws_autoscaling_attachment" "this_elb" {
  count                  = 0    ####If this is set to 0, this resource wont be computed.
  autoscaling_group_name = "${aws_autoscaling_group.this.id}"
  elb                    = "${var.elb_id}"
}

#######auto Scaling ELB Attachment###########
resource "aws_autoscaling_attachment" "this_tg" {
  count                  = "${var.tg_count}"    ####If this is set to 0, this resource wont be computed.
  autoscaling_group_name = "${aws_autoscaling_group.this.*.id[count.index]}"
  alb_target_group_arn   = "{aws_lb_target_group.this_tg_alb.arn}"
}

##########Auto Scaling Policy############
resource "aws_autoscaling_policy" "asp_web_out" {
  name                   = "asp-${var.environment}-${var.product}-web-out"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 900
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
}

resource "aws_autoscaling_policy" "asp_web_in" {
  name                   = "asp-${var.environment}-${var.product}-web-in"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 900
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
}

########Cloud Watch Alarm#########
resource "aws_cloudwatch_metric_alarm" "this_low" {
  alarm_name          = "${var.environment}-${var.product}-web-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "This metric monitors low cpu usage"
  alarm_actions       = ["${aws_autoscaling_policy.asp-web_in.arn}", "${aws_sns_topic.this.arn}"]
  dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.this.name}"
             }
}

resource "aws_cloudwatch_metric_alarm" "this_high" {
  alarm_name          = "${var.environment}-${var.product}-web-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric monitors high cpu usage"
  alarm_actions       = ["${aws_autoscaling_policy.asp_web_out.arn}", "${aws_sns_topic.this.arn}"]
  dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.this.name}"
             }
}

##########Auto Scaling Notification#########
resource "aws_autoscaling_notification" "this" {
  count         = "${var.notify_count}"     ####If this is set to 0, this resource wont be computed.
  group_names   = ["${aws_autoscaling_group.this.name}"]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
]
  topic_arn     = "${aws_sns_topic.this.arn}"
}
