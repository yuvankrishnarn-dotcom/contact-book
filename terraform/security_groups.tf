################################
# Backend Security Group
################################
resource "aws_security_group" "backend_sg" {
  name        = "${var.project}-backend-sg"
  description = "Security group for public backend HTTP service"
  vpc_id      = aws_vpc.main.id

  # Public HTTP access (intentional)
  # tfsec:ignore:aws-ec2-no-public-ingress-sgr
  ingress {
    description = "Allow public HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Restrict outbound to HTTPS only
  egress {
    description = "Allow outbound HTTPS only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-backend-sg"
  }
}

################################
# Database Security Group
################################
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-db-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow PostgreSQL from backend only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  # NO egress rule on purpose
  # Databases should not initiate outbound connections

  tags = {
    Name = "${var.project}-db-sg"
  }
}

