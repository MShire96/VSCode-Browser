data "aws_iam_policy_document" "terraform_cw" {
  statement {
    effect = "Allow"

    actions = [
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:CreateLogGroup",
      "logs:TagResource",
      "logs:ListTagsLogGroup"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_cw" {
  name   = "terrorm_deployment_cw"
  policy = data.aws_iam_policy_document.terraform_cw.json
}

resource "aws_iam_role_policy_attachment" "terraform_cw" {
  role       = aws_iam_role.terraform_deployment.name
  policy_arn = aws_iam_policy.terraform_cw.arn
}