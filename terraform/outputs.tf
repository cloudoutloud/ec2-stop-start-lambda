output "region" {
  description = "AWS Region this Terraform configuration is hosting inside of."
  value       = "${var.aws_region}"
}

output "lambda_function_1" {
  description = "The name of the stop lambda function."
  value       = "${aws_lambda_function.lambda_ec2_stop.function_name}"
}

output "lambda_handler_1" {
  description = "The name of the stop lambda handler - ensure the .py file has the same name."
  value       = "${aws_lambda_function.lambda_ec2_stop.handler}"
}

output "lambda_function_2" {
  description = "The name of the start lambda function."
  value       = "${aws_lambda_function.lambda_ec2_start.function_name}"
}

output "lambda_handler_2" {
  description = "The name of the start lambda handler - ensure the .py file has the same name."
  value       = "${aws_lambda_function.lambda_ec2_start.handler}"
}