resource "aws_eip" "nat-eip" {
    
     depends_on = [aws_internet_gateway.igw]

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0 )
    depends_on = [aws_internet_gateway.igw]

  tags = merge( var.tags,
    {
    Name = format ("%s-NAT", var.name )
    },
  )
}