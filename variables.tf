data "aws_caller_identity" "current" { }

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}


# variable "aws_access_key" {
#   description = "AWS access key"
# }

# variable "aws_secret_key" {
#   description = "AWS secret key"
# }

variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}
