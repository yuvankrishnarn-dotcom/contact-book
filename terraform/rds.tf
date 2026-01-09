resource "aws_db_subnet_group" "db_subnet" {
  name        = "${var.project}-db-subnet-group"
  description = "Subnet group for PostgreSQL RDS"

  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.project}-postgres"

  engine         = "postgres"
  engine_version = "16.6"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "contacts"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 7
  deletion_protection     = true

  performance_insights_enabled = true

  skip_final_snapshot = true

  tags = {
    Name = "${var.project}-postgres"
  }
}

