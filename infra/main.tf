module "aws-ecs-airflow" {
  source                       = "./module"
  aws_region                   = var.aws_region
  availability_zones           = var.availability_zones
  project_name                 = var.project_name
  stage                        = var.stage
  base_cidr_block              = var.base_cidr_block
  log_group_name               = var.log_group_name
  image_version                = var.image_version
  metadata_db_instance_type    = var.metadata_db_instance_type
  celery_backend_instance_type = var.celery_backend_instance_type
  use_flower_service           = true
  num_workers                  = 2
}
