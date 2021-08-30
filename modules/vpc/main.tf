# Create a VPC
resource "aws_vpc" "monese_task_main" {
  cidr_block = var.cidr
  tags = {
    Name = var.vpcName
  }
}

resource "aws_security_group" "allow_inbound_http" {
  name        = var.securityGroupName
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.monese_task_main.id

  dynamic "ingress" {
    for_each = var.sg_ingress
    content {
      
      cidr_blocks = ingress.value["cidr_blocks"]
      from_port = ingress.value["from_port"] 
      to_port = ingress.value["to_port"]
      protocol = ingress.value["protocol"] 
      description = ingress.value["description"]
      }
    }

  dynamic "egress" {
    for_each = var.sg_egress 
      content {
      cidr_blocks = egress.value["cidr_blocks"]
      from_port = egress.value["from_port"] 
      to_port = egress.value["to_port"]
      protocol = egress.value["protocol"] 
    }
  }

  tags = {
    Name = var.securityGroupName
  }
}