[
  {
    "name": "magnifier",
    "image": "nginx:latest",
    "networkMode": "awsvpc",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/magnifier",
        "awslogs-region": "${AWS_REGION}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "containerPort": 22,
        "hostPort": 22
      },
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]