# Get list of availability zones
data "aws_availability_zones" "available" {
  state = "available"
}


# creating sns topic for all the auto scaling groups
resource "aws_sns_topic" "olalekan-sns" {
 name = "Default_CloudWatch_Alarms_Topic"
}
# creating notification for all the auto scaling groups
resource "aws_autoscaling_notification" "olalekan_notifications" {
 group_names = [
   aws_autoscaling_group.bastion.name,
   aws_autoscaling_group.reverseproxy.name,
   aws_autoscaling_group.wordpress.name,
   aws_autoscaling_group.tooling.name,
 ]
 notifications = [
   "autoscaling:EC2_INSTANCE_LAUNCH",
   "autoscaling:EC2_INSTANCE_TERMINATE",
   "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
   "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
 ]

 topic_arn = aws_sns_topic.olalekan-sns.arn
}
resource "random_shuffle" "az_list" {
 input        = data.aws_availability_zones.available.names
}


# autoscaling for bastion hosts
resource "aws_autoscaling_group" "bastion" {
  name                      = "bastion-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
   vpc_zone_identifier = var.public_subnets
  
  launch_template  {
                      id      = aws_launch_template.bastion-launch-template.id
                      version = "$Latest"
                    }
  tag {
    key                 = "Name"
    value               = "ACS-bastion"
    propagate_at_launch = true
  }
}



# autoscaling for reverse proxy
resource "aws_autoscaling_group" "reverseproxy" {
  name                      = "reverseproxy-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  force_delete              = true
  vpc_zone_identifier       = var.public_subnets
  launch_template  {
                      id      = aws_launch_template.nginx-launch-template.id
                      version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "ACS-nginx"
    propagate_at_launch = true
  }
}
# attaching autoscaling group of nginx to external load balancer
# resource "aws_autoscaling_attachment" "asg_attachment_reverseproxy" {
#  autoscaling_group_name = aws_autoscaling_group.reverseproxy.id
#  lb_target_group_arn   = var.nginx-lb-tg
# }



# autoscaling for tooling
resource "aws_autoscaling_group" "tooling" {
  name                      = "tooling-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier = var.private_subnets
  launch_template  {
                      id      = aws_launch_template.tooling-launch-template.id
                      version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "ACS-tooling"
    propagate_at_launch = true
  }
}
# # attaching autoscaling group of  tooling application to internal loadbalancer
# resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
#   autoscaling_group_name = aws_autoscaling_group.tooling.id
#   lb_target_group_arn   = var.tooling-lb-tg
# }


# autoscaling for wordpress
resource "aws_autoscaling_group" "wordpress" {
  name                      = "wordpress-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  force_delete              = true

 
  vpc_zone_identifier       = var.private_subnets

  launch_template  {
                      id      = aws_launch_template.wordpress-launch-template.id
                      version = "$Latest" 
  }
  tag {
    key                 = "Name"
    value               = "ACS-wordpress"
    propagate_at_launch = true
  }
}
# attaching autoscaling group of wordpress application to internal loadbalancer
# resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
#   autoscaling_group_name = aws_autoscaling_group.wordpress.id
#   lb_target_group_arn   = var.wordpress-lb-tg
# }