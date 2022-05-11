resource "aws_vpc" "vpc_company" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "Private company"
  }
}

resource "aws_subnet" "Public-Subnet1" {
  cidr_block = "10.1.1.0/24"
  tags = {
    "Name" = "public subnet 1"
  }
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.vpc_company.id
}

resource "aws_subnet" "Public-Subnet2" {
  cidr_block = "10.1.2.0/24"
  tags = {
    "Name" = "public subnet 2"
  }
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.vpc_company.id
}

resource "aws_subnet" "Public-Subnet3" {
  cidr_block = "10.1.3.0/24"
  tags = {
    "Name" = "public subnet 3"
  }
  availability_zone = "us-east-1c"
  vpc_id            = aws_vpc.vpc_company.id
}

resource "aws_subnet" "Private-Subnet1" {
  cidr_block = "10.1.4.0/24"
  tags = {
    "Name" = "private subnet 1"
  }
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.vpc_company.id
}

resource "aws_subnet" "Private-Subnet2" {
  cidr_block = "10.1.5.0/24"
  tags = {
    "Name" = "private subnet 2"
  }
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.vpc_company.id
}

resource "aws_subnet" "Private-Subnet3" {
  cidr_block = "10.1.6.0/24"
  tags = {
    "Name" = "private subnet 3"
  }
  availability_zone = "us-east-1c"
  vpc_id            = aws_vpc.vpc_company.id
}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.vpc_company.id
  tags = {
    "Name" = "Public Route Table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGW.id
  }
}

resource "aws_route_table" "private_RT1" {
  vpc_id = aws_vpc.vpc_company.id

  tags = {
    "Name" = "Private Route Table1"
  }
  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_nat_gateway.nat_gateway1.id
  }
}

resource "aws_route_table" "private_RT2" {
  vpc_id = aws_vpc.vpc_company.id
  tags = {
    "Name" = "Private Route Table2"
  }
  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_nat_gateway.nat_gateway2.id
  }
}

resource "aws_route_table" "private_RT3" {
  vpc_id = aws_vpc.vpc_company.id
  tags = {
    "Name" = "Private Route Table3"
  }
  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_nat_gateway.nat_gateway3.id
  }
}

resource "aws_internet_gateway" "InternetGW" {
  vpc_id = aws_vpc.vpc_company.id
  tags = {
    "Name" = "Internet GW"
  }
}
resource "aws_eip" "Elastic_IP1" {
  vpc = true
  depends_on = [

    aws_internet_gateway.InternetGW

  ]
}

resource "aws_eip" "Elastic_IP2" {
  vpc = true
  depends_on = [

    aws_internet_gateway.InternetGW

  ]
}

resource "aws_eip" "Elastic_IP3" {
  vpc = true
  depends_on = [

    aws_internet_gateway.InternetGW

  ]
}

resource "aws_nat_gateway" "nat_gateway1" {
  allocation_id = aws_eip.Elastic_IP1.id
  subnet_id     = aws_subnet.Public-Subnet1.id
  tags = {
    Name = "nat_gateway1"

  }
  depends_on = [

    aws_eip.Elastic_IP1

  ]
}

resource "aws_nat_gateway" "nat_gateway2" {
  allocation_id = aws_eip.Elastic_IP2.id
  subnet_id     = aws_subnet.Public-Subnet2.id
  tags = {
    Name = "nat_gateway2"
  }
  depends_on = [

    aws_eip.Elastic_IP2

  ]
}

resource "aws_nat_gateway" "nat_gateway3" {
  allocation_id = aws_eip.Elastic_IP3.id
  subnet_id     = aws_subnet.Public-Subnet3.id
  tags = {
    Name = "nat_gateway3"
  }
  depends_on = [

    aws_eip.Elastic_IP3
  ]
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_company.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group"
  }
}


resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.amznlx2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "ec2-key"
  user_data                   = file("app_server.sh")
  subnet_id                   = aws_subnet.Private-Subnet1.id
  security_groups             = [aws_security_group.allow_tls.id]
  tags = {
    "Name" = "app_server"
  }
}
resource "aws_instance" "dev_server" {
  ami                         = data.aws_ami.amznlx2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "ec2-key"
  user_data                   = file("dev_server.sh")
  subnet_id                   = aws_subnet.Private-Subnet2.id
  security_groups             = [aws_security_group.allow_tls.id]
  tags = {
    "Name" = "dev_server"
  }
}
resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.amznlx2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "ec2-key"
  user_data                   = file("web_server.sh")
  subnet_id                   = aws_subnet.Private-Subnet3.id
  security_groups             = [aws_security_group.allow_tls.id]
  tags = {
    "Name" = "web_server"
  }
}
resource "aws_route_table_association" "publicRT1" {
  subnet_id      = aws_subnet.Public-Subnet1.id
  route_table_id = aws_route_table.public_RT.id
}
resource "aws_route_table_association" "publicRT2" {
  subnet_id      = aws_subnet.Public-Subnet2.id
  route_table_id = aws_route_table.public_RT.id
}
resource "aws_route_table_association" "publicRT3" {
  subnet_id      = aws_subnet.Public-Subnet3.id
  route_table_id = aws_route_table.public_RT.id
}
resource "aws_route_table_association" "privateRT1" {
  subnet_id      = aws_subnet.Private-Subnet1.id
  route_table_id = aws_route_table.private_RT1.id
}
resource "aws_route_table_association" "privateRT2" {
  subnet_id      = aws_subnet.Private-Subnet2.id
  route_table_id = aws_route_table.private_RT2.id
}
resource "aws_route_table_association" "privateRT3" {
  subnet_id      = aws_subnet.Private-Subnet3.id
  route_table_id = aws_route_table.private_RT3.id
}
data "aws_ami" "amznlx2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"

    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "app_server" {
  name_prefix                 = "app-server"
  image_id                    = data.aws_ami.amznlx2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_tls.id]
  user_data                   = file("app_server.sh")
  lifecycle {
    create_before_destroy = true
  }
  key_name = "ec2-key"
}

resource "aws_launch_configuration" "dev_server" {
  name_prefix                 = "dev-server"
  image_id                    = data.aws_ami.amznlx2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_tls.id]
  user_data                   = file("dev_server.sh")
  lifecycle {
    create_before_destroy = true
  }
  key_name = "ec2-key"
}

resource "aws_launch_configuration" "web_server" {
  name_prefix                 = "web-server"
  image_id                    = data.aws_ami.amznlx2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_tls.id]
  user_data                   = file("web_server.sh")
  lifecycle {
    create_before_destroy = true
  }
  key_name = "ec2-key"
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "app-target-group"
  protocol = "HTTP"
  port     = 80

  vpc_id = aws_vpc.vpc_company.id
  health_check {
    interval            = 70
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    matcher             = "200,202"
  }
}
resource "aws_lb_target_group" "dev_target_group" {
  name     = "dev-target-group"
  protocol = "HTTP"
  port     = 80

  vpc_id = aws_vpc.vpc_company.id
  health_check {
    interval = 70
    path     = "/index.html"

    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    matcher             = "200,202"
  }
}
resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  protocol = "HTTP"
  port     = 80

  vpc_id = aws_vpc.vpc_company.id
  health_check {
    interval            = 70
    path                = "/index.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    matcher             = "200,202"
  }
}
resource "aws_autoscaling_group" "app_scaling_rule" {
  name                 = "ec2-scaling1"
  vpc_zone_identifier  = [aws_subnet.Private-Subnet1.id]
  launch_configuration = aws_launch_configuration.app_server.name
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  force_delete         = true
  health_check_type    = "EC2"
  lifecycle {
    create_before_destroy = true
  }
  target_group_arns = [aws_lb_target_group.app_target_group.arn]
  tag {

    key                 = "Name"
    value               = "APP-SERVER"
    propagate_at_launch = true

  }
}

resource "aws_autoscaling_group" "dev_scaling_rule" {
  name                 = "ec2-scaling2"
  vpc_zone_identifier  = [aws_subnet.Private-Subnet2.id]
  launch_configuration = aws_launch_configuration.dev_server.name
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  force_delete         = true
  health_check_type    = "EC2"
  lifecycle {
    create_before_destroy = true
  }
  target_group_arns = [aws_lb_target_group.dev_target_group.arn]
  tag {

    key                 = "Name"
    value               = "DEV-SERVER"
    propagate_at_launch = true

  }
}


resource "aws_autoscaling_group" "web_scaling_rule" {
  name                 = "ec2-scaling3"
  vpc_zone_identifier  = [aws_subnet.Private-Subnet3.id]
  launch_configuration = aws_launch_configuration.web_server.name
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  force_delete         = true
  health_check_type    = "EC2"
  lifecycle {
    create_before_destroy = true
  }
  target_group_arns = [aws_lb_target_group.web_target_group.arn]
  tag {

    key                 = "Name"
    value               = "WEB-SERVER"
    propagate_at_launch = true

  }
}

resource "aws_security_group" "lb_security_group" {
  name        = "lb-security-group"
  description = "Allow traffic to asg"
  vpc_id      = aws_vpc.vpc_company.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {

    Name = "Load-Balancer-Security-Group"

  }
}

resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = [aws_subnet.Public-Subnet1.id, aws_subnet.Public-Subnet2.id, aws_subnet.Public-Subnet3.id]
  tags = {
    "Name" = "app-ALB"
  }
}

resource "aws_lb" "dev_alb" {
  name               = "dev-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = [aws_subnet.Public-Subnet1.id, aws_subnet.Public-Subnet2.id, aws_subnet.Public-Subnet3.id]
  tags = {
    "Name" = "dev-ALB"
  }
}

resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = [aws_subnet.Public-Subnet1.id, aws_subnet.Public-Subnet2.id, aws_subnet.Public-Subnet3.id]
  tags = {
    "Name" = "web-ALB"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}

resource "aws_lb_listener" "dev_listener" {
  load_balancer_arn = aws_lb.dev_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_target_group.arn
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

output "APP_SERVER" {

  value = aws_lb.app_alb.dns_name

}

output "DEV_SERVER" {

  value = aws_lb.dev_alb.dns_name

}

output "WEB_SERVER" {

  value = aws_lb.web_alb.dns_name

}


