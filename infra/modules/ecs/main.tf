resource "aws_ecs_cluster" "vscode_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_service" "vscode_service" {
  name            = "vscode"
  cluster         = aws_ecs_cluster.vscode_cluster.id
  task_definition = aws_ecs_task_definition.vscode_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.ecs_task_name
    container_port   = 8080
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }
}



resource "aws_ecs_task_definition" "vscode_task" {
  family                   = var.vscode_family
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = var.ecs_task_name
      image     = var.vscoder_ecr_imageuri
      essential = true
      environment = [
        {
          name = "PASSWORD"
          value = "changeme"
        }
      ]
      portMappings = [
        {
          containerPort = 8080
        }
      ]
    }
  ])
}

resource "aws_security_group" "ecs" {
  name   = var.ecs_sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
