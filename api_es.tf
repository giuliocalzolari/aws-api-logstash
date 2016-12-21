# First, we need a role to play with Lambda
resource "aws_iam_role" "iam_role_es_api" {
  name = "iam_role_es_api"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "LambdaApiEsPolicy" {
    name   = "LambdaApiEsPolicy"
    role   = "${aws_iam_role.iam_role_es_api.name}"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ],
      "Effect": "Allow"
    }
  ]
}
POLICY
}



# Here is a first lambda function that will run the code `api-es-base.handler`
module "lambda" {
  source  = "./lambda"
  name    = "api-es-base"
  runtime = "python2.7"
  role    = "${aws_iam_role.iam_role_es_api.arn}"
}

output "lambda_function_role_id" {
  value = "${aws_iam_role.iam_role_es_api.arn}"
}


# Now, we need an API to expose those functions publicly
resource "aws_api_gateway_rest_api" "api_es_base" {
  name = "api_es"
  description = "ES API"
}

# The API requires at least one "endpoint", or "resource" in AWS terminology.
# The endpoint created here is: /
resource "aws_api_gateway_resource" "api_es_res" {
  rest_api_id = "${aws_api_gateway_rest_api.api_es_base.id}"
  parent_id   = "${aws_api_gateway_rest_api.api_es_base.root_resource_id}"
  path_part   = "base"
}




output "demo" {
  value = "${module.lambda.name}"
}

# Until now, the resource created could not respond to anything. We must set up
# a HTTP method (or verb) for that!
# This is the code for method ANY /, that will talk to the first lambda
module "base_method" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.api_es_base.id}"
  resource_id = "${aws_api_gateway_resource.api_es_res.id}"
  method      = "ANY"
  path        = "${aws_api_gateway_resource.api_es_res.path}"
  lambda      = "${module.lambda.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}


# We can deploy the API now! (i.e. make it publicly available)
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.api_es_base.id}"
  stage_name  = "production"
  description = "Deploy methods: ${module.base_method.http_method}"
}

