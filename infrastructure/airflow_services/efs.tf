resource "aws_efs_file_system" "foo" {
  creation_token = "airflow-ecs"
  tags = {
    Name = "ECS-EFS-AIRFLOW"
  }
}

resource "aws_efs_mount_target" "mount-a" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = aws_subnet.public-subnet-1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount-b" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      =  aws_subnet.public-subnet-2.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount-c" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      =  aws_subnet.public-subnet-3.id
  security_groups = [aws_security_group.efs_sg.id]
}


resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.foo.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Sid": "ExampleSatement01",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.foo.arn}",
            "Action": [
                "elasticfilesystem:*"
            ]
        }
    ]
}
POLICY
}

resource "aws_security_group" "efs_sg" {
    name = "${var.project_name}-${var.stage}-efs-sg"
    description = "Allow all inbound traffic"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port   = 2049
        to_port     = 2049
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-${var.stage}-efs-sg"
    }
}
