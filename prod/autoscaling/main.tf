data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-state-euan11"
    key    = "terraform/prod-vpc"
    region = "eu-central-1"
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  lifecycle {
    ignore_changes = [public_key]
  }
}

data "aws_ami" "ubuntu1804" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server*"]
  }
}

resource "aws_launch_configuration" "example-launchconfig" {
  name_prefix     = "example-launchconfig"
  image_id        = data.aws_ami.ubuntu1804.id
  instance_type   = var.INSTANCE_SIZE
  key_name        = aws_key_pair.mykeypair.key_name
  security_groups = [aws_security_group.allow-ssh.id]
}

resource "aws_autoscaling_group" "example-autoscaling" {
  name                      = "example-autoscaling"
  vpc_zone_identifier       = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  launch_configuration      = aws_launch_configuration.example-launchconfig.name
  min_size                  = 1
  max_size                  = 4
  health_check_grace_period = 60
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "autoscaling example inst"
    propagate_at_launch = true
  }
}

