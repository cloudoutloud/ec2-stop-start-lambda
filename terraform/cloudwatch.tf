#cloudwatch stop event rule
resource "aws_cloudwatch_event_rule" "lambda_cloudwatch_rule_stop" {
   name = "lambda-stop-instances"
   description = "Triggers lambda to stop instances"
   event_pattern = <<PATTERN
  {
    "source": [
      "aws.ec2"
    ],
    "detail-type": [
      "EC2 Stop Notification"
    ],
    "detail": {
      "event": [
        "stopinstances"
      ],
      "result": [
        "succeeded"
      ]
    }
  }
PATTERN
# Cron job to trigger lambda change time and date below
  schedule_expression = "cron(0 23 ? * MON-FRI *)"
}

#cloudwatch stop event target
resource "aws_cloudwatch_event_target" "lambda_cloudwatch_target_stop_instance" {
    rule = "${aws_cloudwatch_event_rule.lambda_cloudwatch_rule_stop.name}"
    target_id = "SendToLambda"
    arn = "${aws_lambda_function.lambda_ec2_stop.arn}"
}

#Perms for CW to Lambda
resource "aws_lambda_permission" "cloudwatch_to_lambda_stop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_ec2_stop.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda_cloudwatch_rule_stop.arn}"
}

#cloudwatch start event rule
resource "aws_cloudwatch_event_rule" "lambda_cloudwatch_rule_start" {
   name = "lambda-start-instances"
   description = "Triggers lambda to start instances"
   event_pattern = <<PATTERN
  {
    "source": [
      "aws.ec2"
    ],
    "detail-type": [
      "EC2 Stop Notification"
    ],
    "detail": {
      "event": [
        "startinstances"
      ],
      "result": [
        "succeeded"
      ]
    }
  }
PATTERN
# Cron job to trigger lambda change time and date below
  schedule_expression = "cron(0 9 ? * MON-FRI *)"
}

#cloudwatch start event target
resource "aws_cloudwatch_event_target" "lambda_cloudwatch_target_start_instance" {
    rule = "${aws_cloudwatch_event_rule.lambda_cloudwatch_rule_start.name}"
    target_id = "SendToLambda"
    arn = "${aws_lambda_function.lambda_ec2_start.arn}"
}

#Perms for CW to Lambda
resource "aws_lambda_permission" "cloudwatch_to_lambda_start" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_ec2_start.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda_cloudwatch_rule_start.arn}"
}


