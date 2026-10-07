data "aws_iam_policy_document" "terraform_acm" {
  statement {
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZones",
      "route53:ChangeTagsForResource",
      "route53:GetHostedZone",
      "route53:ListTagsForResource",
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:ListResourceRecordSets",
      "acm:RequestCertificate",
      "acm:AddTagsToCertificate",
      "acm:DescribeCertificate",
      "acm:ListTagsForCertificate",
      "acm:DeleteCertificate",
      "acm:CreateCertificate"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_acm" {
  name   = "terrorm_deployment_acm"
  policy = data.aws_iam_policy_document.terraform_acm.json
}

resource "aws_iam_role_policy_attachment" "terraform_acm" {
  role       = aws_iam_role.terraform_deployment.name
  policy_arn = aws_iam_policy.terraform_acm.arn
}