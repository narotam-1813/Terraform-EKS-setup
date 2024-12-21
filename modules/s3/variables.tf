variable "bucket_name" {
  description = "Name of the S3 bucket."
}

variable "iam_role_arn" {
  description = "IAM role ARN for accessing the S3 bucket."
  default     = ""
}