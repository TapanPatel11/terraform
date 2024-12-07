resource "aws_ecs_cluster" "atlantis" {
  name = "${var.app_name}-cluster"
}

data "aws_secretsmanager_secret" "atlantis" {
  name = "Atlantis-secrets"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.atlantis.id
}
resource "aws_ecs_task_definition" "atlantis" {
  family = "${var.app_name}-service"
  container_definitions = jsonencode([
    {
      name             = "atlantis"
      image            = "ghcr.io/runatlantis/atlantis:dev-debian-6363412"
      essential        = true
      environmentFiles = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/atlantis_server"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
          max-buffer-size       = "25m"
          mode                  = "non-blocking"
        }
        secretOptions = []
      }
      environment = [
        {
          name  = "ATLANTIS_GH_TOKEN"
          value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["ATLANTIS_GH_TOKEN"]
        },
        {
          name  = "ATLANTIS_GH_USER"
          value = "tapanpatel11"
        },
        {
          name  = "ATLANTIS_GH_WEBHOOK_SECRET"
          value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["ATLANTIS_GH_WEBHOOK_SECRET"]
        },
        {
          name  = "ATLANTIS_REPO_ALLOWLIST"
          value = "github.com/tapanpatel11/*"
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["AWS_ACCESS_KEY_ID"]
        },
        {
          name  = "AWS_DEFAULT_REGION"
          value = "us-east-1"
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["AWS_SECRET_ACCESS_KEY"]
        },
      ]
      portMappings = [
        {
          name          = "atlantis-4141-tcp"
          containerPort = 4141
          hostPort      = 4141
          protocol      = "tcp"
          appProtocol   = "http"
        },
        {
          appProtocol   = "http"
          containerPort = 80
          hostPort      = 80
          name          = "atlantis-80-tcp"
          protocol      = "tcp"
        },
      ]
      mountPoints    = []
      systemControls = []
      ulimits        = []
      volumesFrom    = []
    }
  ])
  skip_destroy             = false
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::881490087450:role/ecsTaskExecutionRole"
  memory                   = "1024"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "app_service" {
  name            = "${var.app_name}-service"     # Name the service
  cluster         = aws_ecs_cluster.atlantis.id   # Reference the created Cluster
  task_definition = aws_ecs_task_definition.atlantis.arn # Reference the task that the service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 # Set up the number of containers to 3

  load_balancer {
    target_group_arn = data.aws_lb_target_group.tg.arn # Reference the target group
    container_name   = "atlantis"
    container_port   = 4141 # Specify the container port
  }

  network_configuration {
    subnets          = [data.aws_subnet.subnet1.id,data.aws_subnet.subnet2.id,data.aws_subnet.subnet3.id]
    assign_public_ip = true     # Provide the containers with public IPs
    security_groups  = [data.aws_security_group.sg.id] # Set up the security group
  }
}