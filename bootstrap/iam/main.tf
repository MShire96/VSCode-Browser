resource "aws_iam_role" "terraform_deployment" {
  name = "vsc_terraform_deployment_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = var.aws_caller_arn # Who is allowed to assume the role
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "terraform_deployment_iam" {
  name = "terraform-deployment-iam"
  role = aws_iam_role.terraform_deployment.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [  # What is the role allowed to do
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:SetDefaultPolicyVersion",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",

          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",

          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRolePolicy"
        ]

        Resource = "*"
      }
    ]
  })
}