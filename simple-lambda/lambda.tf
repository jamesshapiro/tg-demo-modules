data "aws_s3_object" "lambda_zip" {
  bucket = "athens-build-lambda-code"
  key    = "simple-lambda/archive.zip"
}

resource "aws_iam_role" "simple-lambda-iam" {
  name = "simple-lambda-iam"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

variable "lambda_version" {
    type = string
    description = "Which version of the lambda code to use"
    default = data.aws_s3_object.lambda_zip.version_id
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_logs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.simple-lambda-iam.name
}

resource "aws_lambda_function" "test_lambda" {
    function_name = "simple-lambda"
    role          = aws_iam_role.simple-lambda-iam.arn
    handler       = "function.lambda_handler"
    s3_bucket         = data.aws_s3_object.lambda_zip.id
    s3_key            = data.aws_s3_object.lambda_zip.key
    s3_object_version = var.lambda_version

    runtime = "python3.9"

    environment {
        variables = {
            foo = "bar"
        }
    }
}