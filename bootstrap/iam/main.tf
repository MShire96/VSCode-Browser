resource "aws_iam_role" "terraform_deployment" {
  name = "vsc_terraform_deployment_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = var.aws_caller_arn
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}