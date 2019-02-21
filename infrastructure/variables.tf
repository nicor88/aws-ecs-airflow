variable "project_name" {
   default = "airflow"
}

variable "stage" {
   default = "dev"
}

variable "base_cidr_block" {
   default = "10.0.0.0"
}

variable "availability_zones" {
   type    = "list"
   default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "image_version" {
   default = "latest"
}
