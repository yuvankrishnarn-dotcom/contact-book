resource "aws_security_group" "backend_sg" {
  name        = "${var.project}-backend-sg"
  description = "Backend EC2 security group"
  vpc_id      = aws_vpc.main.id

  # tfsec:ignore:aws-ec2-no-public-ingress-sgr
  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    description = "Allow outbound HTTPS only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project}-db-sg"
  description = "RDS PostgreSQL SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Postgres from backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }
}

