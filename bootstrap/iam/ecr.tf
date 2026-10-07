data "aws_iam_policy_document" "terraform_ecr" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:CreateRepository",
      "ecr:DeleteRepository",
      "ecr:DescribeRepositories",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_ecr" {
  name   = "terrorm_deployment_ecr"
  policy = data.aws_iam_policy_document.terraform_ecr.json
}

resource "aws_iam_role_policy_attachment" "terraform_ecr" {
  role       = aws_iam_role.terraform_deployment.name
  policy_arn = aws_iam_policy.terraform_ecr.arn
}