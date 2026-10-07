data "aws_iam_policy_document" "terraform_ecs" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:DescribeClusters",
      "ecs:DeregisterTaskDefinition",
      "ecs:DeleteCluster",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "ecs:DeleteService",
      "ecs:DescribeTaskDefinition",
      "ecs:CreateService",
      "ecs:RegisterTaskDefinition",
      "ecs:CreateCluster",
      "ecs:UpdateCluster",
      "ecs:TagResource",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_ecs" {
  name   = "terrorm_deployment_ecs"
  policy = data.aws_iam_policy_document.terraform_ecs.json
}

resource "aws_iam_role_policy_attachment" "terraform_ecs" {
  role       = aws_iam_role.terraform_deployment.name
  policy_arn = aws_iam_policy.terraform_ecs.arn
}