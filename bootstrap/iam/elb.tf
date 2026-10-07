data "aws_iam_policy_document" "terraform_elb" {
  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:ModifyListener",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_elb" {
  name   = "terrorm_deployment_elb"
  policy = data.aws_iam_policy_document.terraform_elb.json
}

resource "aws_iam_role_policy_attachment" "terraform_elb" {
  role       = aws_iam_role.terraform_deployment.name
  policy_arn = aws_iam_policy.terraform_elb.arn
}