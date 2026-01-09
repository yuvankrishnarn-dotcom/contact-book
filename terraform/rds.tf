################################
# RDS Monitoring IAM Role
################################
resource "aws_iam_role" "rds_monitoring" {
  name = "${var.project}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

################################
# RDS Parameter Group (Query Logs)
################################
resource "aws_db_parameter_group" "postgres" {
  name   = "${var.project}-pg"
  family = "postgres16"

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }
}

################################
# KMS for RDS
################################
resource "aws_kms_key" "rds" {
  description         = "RDS encryption key"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Action   = "kms:*"
      Resource = "*"
    }]
  })
}

################################
# DB Subnet Group
################################
resource "aws_db_subnet_group" "db" {
  name       = "${var.project}-db-subnet"
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

################################
# RDS Instance (PASS ALL CHECKS)
################################
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

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  publicly_accessible = false
  multi_az            = true

  backup_retention_period      = 7
  auto_minor_version_upgrade   = true
  deletion_protection          = true
  copy_tags_to_snapshot        = true
  iam_database_authentication_enabled = true

  enabled_cloudwatch_logs_exports = ["postgresql"]

  performance_insights_enabled    = true
  performance_insights_kms_key_id = aws_kms_key.rds.arn

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  parameter_group_name = aws_db_parameter_group.postgres.name

  skip_final_snapshot = true
}

