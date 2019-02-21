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



variable "image_version" {
   default = "latest"
}
