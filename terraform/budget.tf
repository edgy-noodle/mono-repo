//noinspection MissingProperty
resource "aws_budgets_budget" "zero_spend" {
  name         = "ZeroSpend"
  budget_type  = "COST"
  limit_amount = "1"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.budget_notifications.arn]
  }
}

resource "aws_sns_topic" "budget_notifications" {
  name = "BudgetNotifications"
}

resource "aws_sns_topic_policy" "budget_notifications_policy" {
  arn    = aws_sns_topic.budget_notifications.arn
  policy = data.aws_iam_policy_document.budget_notifications_policy.json
}

data "aws_iam_policy_document" "budget_notifications_policy" {
  statement {
    actions   = ["SNS:Publish"]
    effect    = "Allow"
    resources = [aws_sns_topic.budget_notifications.arn]

    principals {
      identifiers = ["budgets.amazonaws.com"]
      type        = "Service"
    }
  }
}
resource "awscc_chatbot_slack_channel_configuration" "chatbot_slack" {
  configuration_name = "chatbot_slack"
  iam_role_arn       = aws_iam_role.chatbot_slack.arn
  sns_topic_arns     = [aws_sns_topic.budget_notifications.arn]
  slack_channel_id   = var.slack_channel_id
  slack_workspace_id = var.slack_workspace_id
}

resource "aws_iam_role" "chatbot_slack" {
  name                = "chatbot"
  assume_role_policy  = data.aws_iam_policy_document.chatbot_slack_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSResourceExplorerReadOnlyAccess"]
}

data "aws_iam_policy_document" "chatbot_slack_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["chatbot.amazonaws.com"]
      type        = "Service"
    }
  }
}