resource "aws_iam_policy" "terraform_policy" {
  name   = "AWSTerraformFullAccess"
  policy = data.aws_iam_policy_document.terraform_policy.json
}

data "aws_iam_policy_document" "terraform_policy" {
  statement {
    actions = [
      "sns:*",
      "iam:*",
      "rds:*",
      "s3:*",
      "chatbot:*",
      "lambda:*",
      "cloudformation:*",
      "ec2:*",
      "budgets:*",
      "dynamodb:*",
      "ecr-public:*",
      "ecr:*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy" {
  policy_arn = aws_iam_policy.terraform_policy.arn
  role       = var.aws_terraform_name
}

resource "aws_iam_group_policy_attachment" "terraform_group_policy" {
  policy_arn = aws_iam_policy.terraform_policy.arn
  group      = var.aws_terraform_name
}