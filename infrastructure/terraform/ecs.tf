resource "aws_ecr_repository" "docker_repository" {
    name = "${var.project_name}-${var.stage}"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.stage}"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "ecs/fargate/${var.project_name}-${var.stage}"
  retention_in_days = 5
}

resource "aws_iam_role" "ecs_task_iam_role" {
  name = "${var.project_name}-${var.stage}-ecs-task-role"
  description = "Allow ECS tasks to access AWS resources"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.project_name}-${var.stage}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = "${aws_iam_role.ecs_task_iam_role.name}"
  policy_arn = "${aws_iam_policy.ecs_task_policy.arn}"
}

# TODO add task definition for web server
# TODO add running service for web server

# TODO add task definition for scheduler
# TODO add running service for scheduler

# TODO add task definition for worker
# TODO add running service for worker

# TODO add task definition for flower

# resource "aws_ecs_task_definition" "postgres" {
#   family = "${var.project_name}-${var.stage}-postgres"
#   container_definitions = "${file("airflow-components/metadata_db.json")}"
#   network_mode = "awsvpc"
#   execution_role_arn = "${aws_iam_role.ecs_task_iam_role.arn}"
#   requires_compatibilities = ["FARGATE"]
#   cpu = "1024" # the valid CPU amount for 2 GB is from from 256 to 1024
#   memory = "2048"
# }

# resource "aws_ecs_service" "postgres_service" {
#   name = "${var.project_name}-${var.stage}-postgres"
#   cluster = "${aws_ecs_cluster.ecs_cluster.id}"
#   task_definition = "${aws_ecs_task_definition.postgres.arn}"
#   desired_count = 1 
#   launch_type = "FARGATE"
#   network_configuration {
#     security_groups = ["${aws_security_group.allow_all.id}"]
#     subnets         = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}"]
#     assign_public_ip = "true"
#   }
# }
