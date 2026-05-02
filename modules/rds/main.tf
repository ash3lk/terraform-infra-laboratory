# 1. Subnet group for db
resource "aws_db_subnet_group" "postgres" {
  name       = "${var.env}-rds-subnet-group"
  subnet_ids = var.private_subnets 

  tags = {
    Name = "${var.env}-rds-subnet-group"
  }
}

# 2. DB configuration
resource "aws_db_instance" "postgres" {
  identifier        = "${var.env}-postgres-db"
  engine            = "postgres"
  engine_version    = "15.4"           
  instance_class    = "db.t3.micro"    
  
  allocated_storage     = 20           
  max_allocated_storage = 100          
  storage_type          = "gp3"

  db_name  = "infra-laboratory_db"
  username = "dbadmin"
  password = random_password.db_password.result 

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [var.db_sg_id] 
  
  publicly_accessible    = false       
  skip_final_snapshot    = true        
  
  backup_retention_period = 7          
  multi_az                = false       

  tags = {
    Name = "${var.env}-postgres-database"
  }
}

# 3. Password generation
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$&"
}

# 4. Password in SSM
resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.env}/rds/db_password"
  description = "Master password for ${var.env} database"
  type        = "SecureString"
  value       = random_password.db_password.result
}

# 5. Endpoint in AWS SSM
resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/${var.env}/rds/db_endpoint"
  type  = "String"
  value = aws_db_instance.postgres.endpoint

depends_on = [aws_db_instance.postgres]
}