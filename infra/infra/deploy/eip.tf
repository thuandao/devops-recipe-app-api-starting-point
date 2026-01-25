resource "aws_eip" "bastion" {
  domain = "vpc"
}

resource "aws_eip_association" "bastion" {
  allocation_id = aws_eip.bastion.id
  instance_id   = aws_autoscaling_group.bastion.instances[0]
}
