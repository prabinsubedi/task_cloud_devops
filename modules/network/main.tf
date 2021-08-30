
resource "aws_subnet" "public_subnet" {
    count = length(var.publicSubnet)
    vpc_id = var.vpcId
    cidr_block = var.publicSubnet[count.index]
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = var.availabilityZonePublic[count.index]
    tags = {
        Name = var.subnetPublicName
    }
    
}


resource "aws_route_table" "monese_task_route" {
    vpc_id = var.vpcId
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = var.igwId 
    }
    
    tags = {
        Name = var.routeTableName
    }
}

resource "aws_route_table_association" "route_public_subnet"{
    count = length(var.publicSubnet)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.monese_task_route.id
}