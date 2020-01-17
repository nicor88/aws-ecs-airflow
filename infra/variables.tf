variable "aws_region" {
   default = "eu-west-1"
}

variable "availability_zones" {
   type    = "list"
   default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "project_name" {
   default = "airflow"
}

variable "stage" {
   default = "dev"
}

variable "base_cidr_block" {
   default = "10.0.0.0"
}

variable "log_group_name" {
   default = "ecs/fargate"
}

variable "image_version" {
   default = "latest"
}

variable "metadata_db_instance_type" {
   default = "db.t3.micro"
}

variable "celery_backend_instance_type" {
   default = "cache.t2.small"
}