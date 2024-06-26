# Create private route table
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.main.id

 tags = merge( var.tags,
    {
    Name = format ("%s-private-rtb", var.name )
    },
  )
}

# create route for the private route table and attach a nat gateway to it 
resource "aws_route" "private-rt" {
  route_table_id            = aws_route_table.private-rtb.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.nat.id
}
# associate all private subnets to private route table
resource "aws_route_table_association" "private-route-association" {
  count = length ( aws_subnet.private[*].id)
  subnet_id      = element (aws_subnet.private[*].id , count.index)
  route_table_id = aws_route_table.private-rtb.id
  
 }

# Create public route table
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.main.id

 tags = merge( var.tags,
    {
    Name = format ("%s-public-rtb", var.name )
    },
  )
}

# create route for the public route table and attach a internet gateway to it 
resource "aws_route" "public-rt" {
  route_table_id            = aws_route_table.public-rtb.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}
# associate all public subnets to public route table
resource "aws_route_table_association" "public-route-association" {
  count = length ( aws_subnet.public[*].id)
  subnet_id      = element (aws_subnet.public[*].id , count.index)
  route_table_id = aws_route_table.public-rtb.id
}