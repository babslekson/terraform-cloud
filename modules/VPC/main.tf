# Create VPC
resource "aws_vpc" "main" {
cidr_block                     = var.vpc_cidr
enable_dns_support             = var.enable_dns_support 
enable_dns_hostnames           = var.enable_dns_hostnames

tags = merge(
        var.tags,
        {
            Name = format("%s-vpc", var.name) 

        },
     )

}
# Get list of availabilty zone
data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_subnet" "public" {
    count                      = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
    vpc_id                     = aws_vpc.main.id
    cidr_block                 = var.public_subnets[count.index]
    availability_zone          = data.aws_availability_zones.available.names[count.index]
     map_public_ip_on_launch   = "true"


     tags = merge(
        var.tags,
        {
            Name = format("%s-public-subnet-%s", var.name, count.index + 1) 

        },
     )
}

resource "aws_subnet" "private" {
    count                      = var.preferred_number_of_private_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets
    vpc_id                     = aws_vpc.main.id
    cidr_block                 = var.private_subnets[count.index]
    availability_zone          = data.aws_availability_zones.available.names[count.index]


    tags = merge (
        var.tags, 
        {
            Name = format("%s-private-subnet-%s", var.name , count.index +  1)
        },
    )
}
