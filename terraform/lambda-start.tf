# lambda ec2 start function
resource "aws_lambda_function" "lambda_ec2_start" {
    function_name = "lambda_ec2_start"
    runtime = "python3.6"
    handler = "function.lambda_handler"
    filename = "../function-start/function.zip"
    role  = "${aws_iam_role.lambda_role_ec2_start.arn}"
    timeout = "60"
}

resource "aws_iam_role" "lambda_role_ec2_start" {
  name = "LambdaEc2StartRole"
  assume_role_policy = "${element(data.aws_iam_policy_document.lambda_role_ec2_start_assume_role.*.json, 0)}"
  description        = "Lambda service role for ec2 start function."
}

data "aws_iam_policy_document" "lambda_role_ec2_start_assume_role" {
  statement {
    sid    = "AssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_attachment_ec2_start" {
  role       = "${element(aws_iam_role.lambda_role_ec2_start.*.name, 0)}"
  policy_arn = "${element(aws_iam_policy.lambda_policy_ec2_start.*.arn, 0)}"
}

resource "aws_iam_policy" "lambda_policy_ec2_start" {
  name        = "LambdaEc2startPolicy"
  description = "IAM policy for Lambda access."
  policy      = "${element(data.aws_iam_policy_document.lambda_document_ec2_start.*.json, 0)}"
}

data "aws_iam_policy_document" "lambda_document_ec2_start" {
  policy_id = "LambdaAccess"

  statement {
    sid    = "AllowLambdaAccess"
    effect = "Allow"

    actions = [
      "logs:*",
       "ec2:DescribeInstances",
       "ec2:DescribeRegions",
       "ec2:StartInstances"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowKMSAccess"
    effect = "Allow"

    actions = [
      "kms:*",
    ]

    resources = [
      "arn:aws:kms:eu-central-1:",
      "arn:aws:kms:eu-west-1:",
    ]
  }
}