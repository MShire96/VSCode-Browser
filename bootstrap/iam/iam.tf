data "aws_iam_policy_document" "terraform_iam" {
  statement {
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListAttachedRolePolicies",
      "iam:DeleteRole",
      "iam:ListPolicyVersions",
      "iam:DeletePolicy",
      "iam:DetachRolePolicy",
      "iam:ListRolePolicies",
      "iam:GetRole",
      "iam:GetPolicyVersion",
      "iam:GetPolicy",
      "iam:CreateRole",
      "iam:CreatePolicy",
      "iam:AttachRolePolicy",
      "iam:TagRole",
      "iam:TagPolicy",
      "iam:PassRole",
      "iam:CreateRole"
    ]
    resources = [
      aws_iam_role.terraform_deployment.arn,
      "arn:aws:iam::190285489485:role/ecs-execution-role"
    ]
  }
}
resource "aws_iam_policy" "terraform_iam" {
  name   = "terraform-deployment-iam"
  policy = data.aws_iam_policy_document.terraform_iam.json
}

resource "aws_iam_role_policy_attachment" "terraform_iam" {
  role       = aws_iam_role.terraform_deployment.name
  policy_arn = aws_iam_policy.terraform_iam.arn
}