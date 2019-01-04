[
  {
    "name": "magnifier",
    "image": "nginx",
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
    ],
    "environment": [
      {
        "name": "DATABASE_HOST",
        "value": "${DATABASE_HOST}"
      },
      {
        "name": "DATABASE_USER",
        "value": "${DATABASE_USER}"
      },
      {
        "name": "DATABASE_PORT",
        "value": "${DATABASE_PORT}"
      },
      {
        "name": "DATABASE_PASSWORD",
        "value": "${DATABASE_PASSWORD}"
      }
    ]
  }
]