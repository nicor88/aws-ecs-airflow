output "metadata_db_postgres_password" {
  value = "${random_string.metadata_db_password.result}"
}

output "metadata_db_postgres_endpoint" {
  value = "${aws_db_instance.metadata_db.endpoint}"
}

output "metadata_db_postgres_address" {
  value = "${aws_db_instance.metadata_db.address}"
}

output "celery_backend_address" {
  value = "${aws_elasticache_cluster.celery_backend.cache_nodes.0.address}"
}

output "airflow_web_server_endpoint" {
  value = "${aws_alb.airflow_alb.dns_name}"
} 

