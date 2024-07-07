provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "gemtech-remotestate-dev"
    key     = "ntl/rds/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

locals {
  environment = "dev"
  name        = "ntl-aurora-mysql"
  username    = "ntluser"
  dbname      = "ntldb"
}

##-----------------------------------------------------------------------------
## RDS Aurora Module
##-----------------------------------------------------------------------------
module "aurora" {
  source          = "git@github.com:mauricetjmurphy/gemtech-terraform-modules.git//rds"
  name            = local.name
  environment     = local.environment
  engine          = "aurora-mysql"
  engine_version  = "5.7.mysql_aurora.2.12.3"
  master_username = local.username
  database_name   = "${local.dbname}"
  sg_ids          = []
  allowed_ports   = [3306]
  allowed_ip      = [data.aws_vpc.gemtech_vpc.cidr_block]
  instances = {
    1 = {
      instance_class      = "db.t3.small"  
      publicly_accessible = false
    }
  }

  vpc_id = data.aws_vpc.gemtech_vpc.id

  apply_immediately   = true
  skip_final_snapshot = true
  subnets             = var.private_subnet_ids

  create_db_cluster_parameter_group = true
  db_cluster_parameter_group_name   = "aurora-mysql"
  db_cluster_parameter_group_family = "aurora-mysql5.7"
  db_cluster_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 120
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "immediate"
      }, {
      name         = "max_allowed_packet"
      value        = "67108864"
      apply_method = "immediate"
      }, {
      name         = "binlog_format"
      value        = "ROW"
      apply_method = "pending-reboot"
      }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
      }, {
      name         = "require_secure_transport"
      value        = "ON"
      apply_method = "immediate"
      }, {
      name         = "tls_version"
      value        = "TLSv1.2"
      apply_method = "pending-reboot"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = "aurora-mysql"
  db_parameter_group_family      = "aurora-mysql5.7"
  db_parameter_group_description = "mysql aurora DB parameter group"
  db_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 60
      apply_method = "immediate"
      }, {
      name         = "general_log"
      value        = 0
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "long_query_time"
      value        = 5
      apply_method = "immediate"
      }, {
      name         = "max_connections"
      value        = 2000
      apply_method = "immediate"
      }, {
      name         = "slow_query_log"
      value        = 1
      apply_method = "immediate"
      }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
    }
  ]

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name                    = "${local.name}-${local.environment}"
  description             = "RDS database credentials for ${local.name}-${local.environment}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_cluster" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    "dbClusterIdentifier" : module.aurora.cluster_id,
    "engine" : "MYSQL",
    "host" : module.aurora.cluster_endpoint,
    "post" : 3306,
    "username" : module.aurora.cluster_master_username,
    "password" : module.aurora.cluster_master_password,
    "dbname" : "${local.dbname}"
  })
}