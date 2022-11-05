locals {
  object_source = "${path.module}/source.zip"
}

module "nphc_vpc" {
  source = "./terraform-modules/modules/networking"
  cidr_block = "10.0.0.0/16"
  availability_zone_count = 3
}

module "nphc_elb" {
  source = "./terraform-modules/modules/elb"
  vpc_id = module.nphc_vpc.vpc_id
  loadbalancer_type = "application"
  loadbalancer_security_group_ids = [module.nphc_vpc.open_security_groups]
  target_group_type = "instance"
  loadbalancer_subnets = [module.nphc_vpc.private_subnets[0], module.nphc_vpc.private_subnets[1], module.nphc_vpc.private_subnets[2]] 
}

module "nphc_s3" {
  source = "./terraform-modules/modules/s3"
  bucket_name = "nphc-vinod-s3-bucket"
}

resource "aws_s3_object" "file_upload" {
  bucket      = module.nphc_s3.bucket_name
  key         = "source-code"
  source      = local.object_source
  source_hash = filemd5(local.object_source)
}

resource "aws_iam_role" "s3_read_role" {
  name = "s3_read_role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  }


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.s3_read_role.name
}


data "aws_availability_zones" "all" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.nphc_vpc.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [module.nphc_vpc.open_security_groups]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

data "template_file" "startup" {
 template = file("setup.sh")
}

resource "aws_launch_configuration" "aws_lc_conf" {
  name_prefix   = "terraform-lc-nphc-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = "sg_key_pair"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  security_groups = [ aws_security_group.allow_traffic.id ]
  user_data = data.template_file.startup.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "aws_asg_configuration" {
  desired_capacity = 3
  vpc_zone_identifier = [module.nphc_vpc.private_subnets[0], module.nphc_vpc.private_subnets[1], module.nphc_vpc.private_subnets[2]]
  name_prefix                 = "terraform-asg-nphc-"
  launch_configuration = aws_launch_configuration.aws_lc_conf.name
  target_group_arns = [module.nphc_elb.target_group_arn]
  min_size             = 3
  max_size             = 6

  lifecycle {
    create_before_destroy = true
  }
}