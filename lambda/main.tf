variable "name" {
  description = "The name of the lambda to create, which also defines (i) the archive name (.zip), (ii) the file name, and (iii) the function name"
}

variable "runtime" {
  description = "The runtime of the lambda to create"
  default     = "nodejs"
}

variable "handler" {
  description = "The handler name of the lambda (a function defined in your lambda)"
  default     = "handler"
}

variable "role" {
  description = "IAM role attached to the Lambda Function (ARN)"
}

resource "aws_lambda_function" "lambda" {
  filename      = "./lambda/function/${var.name}.zip"
  function_name = "${var.name}"
  role          = "${var.role}"
  handler       = "${var.name}.${var.handler}"
  runtime       = "${var.runtime}"
  source_code_hash  = "${base64sha256(file("./lambda/function/${var.name}.zip"))}"
}

output "name" {
  value = "${aws_lambda_function.lambda.function_name}"
}
