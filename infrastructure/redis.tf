resource "aws_security_group" "redis_vpc" {
  name        = "${var.project_name}-${var.stage}-redis-vpc-sg"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${var.base_cidr_block}/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.stage}-redis-vpc-sg"
  }
}

resource "aws_elasticache_subnet_group" "airflow_redis_subnet_group" {
  name       = "${var.project_name}-${var.stage}"
  subnet_ids = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-3.id]
}

resource "aws_elasticache_cluster" "celery_backend" {
  cluster_id         = "${var.project_name}-${var.stage}"
  engine             = "redis"
  engine_version     = "4.0.10"
  node_type          = var.celery_backend_instance_type
  num_cache_nodes    = 1
  port               = "6379"
  subnet_group_name  = aws_elasticache_subnet_group.airflow_redis_subnet_group.id
  security_group_ids = [aws_security_group.redis_vpc.id]
}

