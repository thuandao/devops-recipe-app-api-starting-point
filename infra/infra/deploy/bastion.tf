
data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_iam_role" "bastion" {
  name               = "${local.prefix}-bastion"
  assume_role_policy = file("./templates/bastion/instance-profile-policy.json")

  tags = {
    Name = "${local.prefix}-bastion_aws_iam_role"
  }
}

resource "aws_iam_role_policy_attachment" "bastion_attach_policy" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.prefix}-bastion-instance-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_launch_template" "bastion" {
  name_prefix   = "${local.prefix}-launch-template-bastion"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.bastion_key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.bastion.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.bastion.id]
    subnet_id                   = aws_subnet.public_a.id
  }

  user_data = base64encode(
    file("./templates/bastion/user-data.sh")
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.prefix}-aws-launch-template-bastion"
    }
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                = "${local.prefix}-bastion-asg"
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.public_a.id]

  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "${local.prefix}-bastion-autoscaling-group"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "bastion" {
  description = "Control bastion inbound and outbound access"
  name        = "${local.prefix}-bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
      aws_subnet.private_a.cidr_block,
      aws_subnet.private_b.cidr_block,
    ]
  }

  tags = {
    Name = "${local.prefix}-bastion"
  }
}
