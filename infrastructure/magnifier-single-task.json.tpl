[
  {
    "name": "magnifier-single-task",
    "image": "${registry_url}:latest",
    "networkMode": "awsvpc",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/magnifier-single-task",
        "awslogs-region": "${AWS_REGION}",
        "awslogs-stream-prefix": "ecs"
      }
    },
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
      },
      {
        "name": "RAILS_LOG_TO_STDOUT",
        "value": "true"
      }
    ],
    "command": [
      "rails db:migrate"
    ]
  }
]