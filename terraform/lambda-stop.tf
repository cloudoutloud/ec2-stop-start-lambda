# lambda ec2 stop function
resource "aws_lambda_function" "lambda_ec2_stop" {
    function_name = "lambda_ec2_stop"
    runtime = "python3.6"
    handler = "function.lambda_handler"
    filename = "../function-stop/function.zip"
    role  = "${aws_iam_role.lambda_role_ec2_stop.arn}"
    timeout = "60"
}

resource "aws_iam_role" "lambda_role_ec2_stop" {
  name = "LambdaEc2StopRole"
  assume_role_policy = "${element(data.aws_iam_policy_document.lambda_role_ec2_stop_assume_role.*.json, 0)}"
  description        = "Lambda service role for ec2 stop function."
}

data "aws_iam_policy_document" "lambda_role_ec2_stop_assume_role" {
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

resource "aws_iam_role_policy_attachment" "lambda_attachment_ec2_stop" {
  role       = "${element(aws_iam_role.lambda_role_ec2_stop.*.name, 0)}"
  policy_arn = "${element(aws_iam_policy.lambda_policy_ec2_stop.*.arn, 0)}"
}

resource "aws_iam_policy" "lambda_policy_ec2_stop" {
  name        = "LambdaEc2stopPolicy"
  description = "IAM policy for Lambda access."
  policy      = "${element(data.aws_iam_policy_document.lambda_document_ec2_stop.*.json, 0)}"
}

data "aws_iam_policy_document" "lambda_document_ec2_stop" {
  policy_id = "LambdaAccess"

  statement {
    sid    = "AllowLambdaAccess"
    effect = "Allow"

    actions = [
      "logs:*",
       "ec2:DescribeInstances",
       "ec2:DescribeRegions",
       "ec2:StopInstances"
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