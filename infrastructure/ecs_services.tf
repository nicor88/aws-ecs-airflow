resource "aws_ecs_service" "web_server_service" {
    name = "${var.project_name}-${var.stage}-web-server"
    cluster = "${aws_ecs_cluster.ecs_cluster.id}"
    task_definition = "${aws_ecs_task_definition.web_server.arn}"
    desired_count = 2
    launch_type = "FARGATE"
    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100
    health_check_grace_period_seconds = 60

    network_configuration {
        security_groups = ["${aws_security_group.web_server_ecs_internal.id}"]
        subnets         = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}", "${aws_subnet.public-subnet-3.id}"]
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = "${aws_alb_target_group.airflow_web_server.id}"
        container_name   = "airflow_web_server"
        container_port   = 8080
    }

    depends_on = [
        "aws_db_instance.metadata_db",
        "aws_elasticache_cluster.celery_backend",
        "aws_alb_listener.airflow_web_server",
    ]
}

resource "aws_ecs_service" "scheduler_service" {
    name = "${var.project_name}-${var.stage}-scheduler"
    cluster = "${aws_ecs_cluster.ecs_cluster.id}"
    task_definition = "${aws_ecs_task_definition.scheduler.arn}"
    desired_count = 1 
    launch_type = "FARGATE"
    
    network_configuration {
        security_groups = ["${aws_security_group.scheduler.id}"]
        subnets = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}", "${aws_subnet.public-subnet-3.id}"]
        assign_public_ip = true # when using a NAT can be put to false
    }

    depends_on = [
        "aws_db_instance.metadata_db",
        "aws_elasticache_cluster.celery_backend",
    ]
}

resource "aws_ecs_service" "workers_service" {
    name = "${var.project_name}-${var.stage}-workers"
    cluster = "${aws_ecs_cluster.ecs_cluster.id}"
    task_definition = "${aws_ecs_task_definition.workers.arn}"
    desired_count = 3
    launch_type = "FARGATE"

    network_configuration {
        security_groups = ["${aws_security_group.workers.id}"]
        subnets = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}", "${aws_subnet.public-subnet-3.id}"]
        assign_public_ip = true # when using a NAT can be put to false
    }

    depends_on = [
        "aws_db_instance.metadata_db",
        "aws_elasticache_cluster.celery_backend",
    ]
}

resource "aws_ecs_service" "flower_service" {
    name = "${var.project_name}-${var.stage}-flower"
    cluster = "${aws_ecs_cluster.ecs_cluster.id}"
    task_definition = "${aws_ecs_task_definition.flower.arn}"
    desired_count = 1 
    launch_type = "FARGATE"

    network_configuration {
        security_groups = ["${aws_security_group.flower.id}"]
        subnets = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}", "${aws_subnet.public-subnet-3.id}"]
        assign_public_ip = true
    }

    depends_on = [
        "aws_db_instance.metadata_db",
        "aws_elasticache_cluster.celery_backend",
    ]
}
