resource "aws_iam_role" "blog_api_lambda_exec" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_dynamodb_access" {
  name = var.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::gbs-blog-articles-climate-change/*",
          "arn:aws:s3:::gbs-blog-articles-green-tech/*"
        ]
      },
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:dynamodb:us-east-1:144817152095:table/gbs-blog-articles-prod",
          "arn:aws:dynamodb:us-east-1:144817152095:table/gbs-blog-mailing-list-prod",
          "arn:aws:dynamodb:us-east-1:144817152095:table/gbs-blog-messages-prod",
          "arn:aws:dynamodb:us-east-1:144817152095:table/gbs-blog-posts-prod",
          "arn:aws:dynamodb:us-east-1:144817152095:table/gbs-blog-topics-prod",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_dynamodb_access" {
  policy_arn = aws_iam_policy.lambda_s3_dynamodb_access.arn
  role       = aws_iam_role.blog_api_lambda_exec.name
}
