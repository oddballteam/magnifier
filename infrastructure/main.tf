provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  version    = "~> 1.35"
}

terraform {
  backend "s3" {
    bucket = "magnifier-tf"
    key    = "magnifier.tfstate"
    region = "us-east-1"
  }
}

# Workaround, allowing interpolation in variables
locals {
  azs = "${var.AWS_REGION}a,${var.AWS_REGION}b"
}

resource "aws_alb" "magnifier" {
  name         = "magnifier"
  internal     = false
  idle_timeout = 90

  security_groups = [
    "${aws_security_group.ecs.id}",
    "${aws_security_group.alb.id}",
  ]

  subnets = [
    "${module.base_vpc.public_subnets[0]}",
    "${module.base_vpc.public_subnets[1]}",
  ]
}

resource "aws_alb_target_group" "magnifier" {
  name        = "magnifier"
  protocol    = "HTTP"
  port        = "${var.container_port}"
  vpc_id      = "${module.base_vpc.vpc_id}"
  target_type = "ip"

  health_check {
    path = "/"
  }
}

resource "aws_alb_listener" "magnifier" {
  load_balancer_arn = "${aws_alb.magnifier.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.magnifier.arn}"
    type             = "forward"
  }

  depends_on = ["aws_alb_target_group.magnifier"]
}

resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "Allow traffic for ecs"
  vpc_id      = "${module.base_vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.CIDR_PUBLIC)}"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.CIDR_PRIVATE)}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow traffic for alb"
  vpc_id      = "${module.base_vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "base_vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"

  name = "base_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${split(",", local.azs)}"]
  private_subnets = ["${split(",", var.CIDR_PRIVATE)}"]
  public_subnets  = ["${split(",", var.CIDR_PUBLIC)}"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Application = "magnifier"
  }
}

resource "aws_iam_role" "ecs_task_assume" {
  name = "ecs_task_assume"

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

resource "aws_iam_role_policy" "ecs_task_assume" {
  name = "ecs_task_assume"
  role = "${aws_iam_role.ecs_task_assume.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

data "template_file" "magnifier" {
  template = "${file("magnifier.json.tpl")}"

  vars {
    REPOSITORY_URL    = "${aws_ecr_repository.magnifier.repository_url}"
    AWS_REGION        = "${var.AWS_REGION}"
    LOGS_GROUP        = "${aws_cloudwatch_log_group.magnifier.name}"
    DATABASE_URL      = "${aws_db_instance.default.endpoint}"
    DATABASE_HOST     = "${aws_db_instance.default.address}"
    DATABASE_USER     = "${var.db_user}"
    DATABASE_PORT     = "${aws_db_instance.default.port}"
    DATABASE_PASSWORD = "${var.db_pass}"
    registry_url      = "${aws_ecr_repository.magnifier.repository_url}"
  }

  depends_on = ["aws_ecr_repository.magnifier", "aws_cloudwatch_log_group.magnifier", "aws_db_instance.default"]
}

resource "aws_ecs_task_definition" "magnifier" {
  family                   = "magnifier"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = "${data.template_file.magnifier.rendered}"
  execution_role_arn       = "${aws_iam_role.ecs_task_assume.arn}"

  tags = {
    Terraform   = "true"
    Application = "magnifier"
  }
}

resource "aws_ecs_service" "magnifier" {
  name            = "magnifier"
  cluster         = "${aws_ecs_cluster.fargate.id}"
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.magnifier.arn}"
  desired_count   = 1

  network_configuration = {
    subnets         = ["${module.base_vpc.private_subnets[0]}"]
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.magnifier.arn}"
    container_name   = "magnifier"
    container_port   = "${var.container_port}"
  }

  depends_on = [
    "aws_alb_listener.magnifier",
  ]
}

resource "aws_ecs_cluster" "fargate" {
  name = "fargate"

  tags = {
    Terraform   = "true"
    Application = "magnifier"
  }
}

resource "aws_ecr_repository" "magnifier" {
  name = "magnifier"
}

resource "aws_cloudwatch_log_group" "magnifier" {
  name              = "/ecs/magnifier"
  retention_in_days = 30

  tags {
    Name        = "magnifier"
    Application = "magnifier"
    Terraform   = "true"
  }
}

resource "aws_cloudwatch_log_group" "magnifier_single_task" {
  name              = "/ecs/magnifier-single-task"
  retention_in_days = 30

  tags {
    Name        = "magnifier"
    Application = "magnifier"
    Terraform   = "true"
  }
}

resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow postgres traffic inbound"
  vpc_id      = "${module.base_vpc.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  tags {
    Application = "magnifier"
    Terraform   = "true"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage          = 10
  storage_type               = "gp2"
  engine                     = "postgres"
  engine_version             = "10.4"
  instance_class             = "db.t2.micro"
  name                       = "${var.db_name}"
  username                   = "${var.db_user}"
  password                   = "${var.db_pass}"
  vpc_security_group_ids     = ["${aws_security_group.allow_postgres.id}"]
  skip_final_snapshot        = "true"
  db_subnet_group_name       = "${aws_db_subnet_group.magnifier_db.name}"
  auto_minor_version_upgrade = "true"

  tags {
    Application = "magnifier"
    Terraform   = "true"
  }
}

resource "aws_db_subnet_group" "magnifier_db" {
  name = "magnifier-db-subnet"

  subnet_ids = [
    "${module.base_vpc.public_subnets[0]}",
    "${module.base_vpc.public_subnets[1]}",
  ]

  tags {
    Application = "magnifier"
    Terraform   = "true"
  }
}

data "template_file" "magnifier_single_task" {
  template = "${file("magnifier-single-task.json.tpl")}"

  vars {
    REPOSITORY_URL    = "${aws_ecr_repository.magnifier.repository_url}"
    AWS_REGION        = "${var.AWS_REGION}"
    LOGS_GROUP        = "${aws_cloudwatch_log_group.magnifier_single_task.name}"
    DATABASE_URL      = "${aws_db_instance.default.endpoint}"
    DATABASE_HOST     = "${aws_db_instance.default.address}"
    DATABASE_USER     = "${var.db_user}"
    DATABASE_PORT     = "${aws_db_instance.default.port}"
    DATABASE_PASSWORD = "${var.db_pass}"
    registry_url      = "${aws_ecr_repository.magnifier.repository_url}"
  }

  depends_on = ["aws_ecr_repository.magnifier", "aws_cloudwatch_log_group.magnifier_single_task", "aws_db_instance.default"]
}

resource "aws_ecs_task_definition" "magnifier_single_task" {
  family                   = "magnifier-single-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = "${data.template_file.magnifier_single_task.rendered}"
  execution_role_arn       = "${aws_iam_role.ecs_task_assume.arn}"

  tags = {
    Terraform   = "true"
    Application = "magnifier"
  }
}
