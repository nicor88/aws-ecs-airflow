resource "aws_security_group" "scheduler" {
    name = "${var.project_name}-${var.stage}-scheduler-sg"
    description = "Airflow scheduler security group"
    vpc_id = aws_vpc.vpc.id

   ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-${var.stage}-scheduler-sg"
    }
}


resource "aws_ecs_task_definition" "scheduler" {
  family = "${var.project_name}-${var.stage}-scheduler"
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_iam_role.arn
  task_role_arn = aws_iam_role.ecs_task_iam_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu = "1024" # the valid CPU amount for 2 GB is from from 256 to 1024
  memory = "2048"
  volume {
    name  = var.volume_efs_name
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.foo.id
      root_directory = var.volume_efs_root_directory
    }
  }
  container_definitions = templatefile("${path.module}/task_definitions/airflow_services.json", {
       service_name       = "scheduler"
       command            = "scheduler"
       ecr_image          = "${aws_ecr_repository.docker_repository.repository_url}:latest",
       port               = 80
       stage              = var.stage
       db_credentials     = "airflow:${random_string.metadata_db_password.result}@${aws_db_instance.metadata_db.address}:5432/airflow"
       redis_url          = "${aws_elasticache_cluster.celery_backend.cache_nodes.0.address}:6379"
       awslogs_group      = "${var.log_group_name}/${var.project_name}-${var.stage}",
       awslogs_region     = var.aws_region
       path_airflow_dags  = var.airflow_local_folder_dags
       path_remote_logs   = "cloudwatch://${aws_cloudwatch_log_group.log_group_tasks.arn}"
  })
}
