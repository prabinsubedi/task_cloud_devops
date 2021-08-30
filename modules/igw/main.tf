resource "aws_internet_gateway" "monese_gateway" {
  vpc_id = var.vpcId

  tags = {
    Name = var.igwName
  }
}