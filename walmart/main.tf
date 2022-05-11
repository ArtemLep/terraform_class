resource "aws_vpc" "vpc_walmart" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_walmart" {
    vpc_id = aws_vpc.vpc_walmart.id
cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "private_subnet_walmart" {
        vpc_id = aws_vpc.vpc_walmart.id
cidr_block = "10.0.2.0/24"
}
resource "aws_internet_gateway" "internet_gateway_walmart" {
        vpc_id = aws_vpc.vpc_walmart.id
}
resource "aws_route_table" "route_tb_public_walmart" {
        vpc_id = aws_vpc.vpc_walmart.id
        
}
resource "aws_route_table" "route_tb_private_walmart" {
        vpc_id = aws_vpc.vpc_walmart.id

}