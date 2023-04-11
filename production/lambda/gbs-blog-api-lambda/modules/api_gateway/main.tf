resource "aws_api_gateway_rest_api" "main" {
  name        = var.api_gateway_name
}

resource "aws_cloudwatch_log_group" "main_api_gw" {
  name = "/aws/api-gw/${aws_api_gateway_rest_api.main.name}"

  retention_in_days = 14
}

resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_lambda" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_any.http_method

  type          = "AWS_PROXY"
  uri           = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "proxy_any_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_any.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy_any_200" {
  depends_on  = [aws_api_gateway_integration.proxy_lambda]
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_any.http_method
  status_code = aws_api_gateway_method_response.proxy_any_200.status_code
}

# API Gateway resources for each route
resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_resource" "articles" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "articles"
}

resource "aws_api_gateway_resource" "climate_articles" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "climate-articles"
}

resource "aws_api_gateway_resource" "emails" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "emails"
}

resource "aws_api_gateway_resource" "message" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "message"
}

resource "aws_api_gateway_resource" "post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "post"
}

resource "aws_api_gateway_resource" "posts" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "posts"
}

resource "aws_api_gateway_resource" "signup" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "signup"
}

resource "aws_api_gateway_resource" "tech_articles" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "tech-articles"
}

# Define the API Gateway methods and integrations for each route

# Helper locals for method and integration options
locals {
  authorization = "NONE"
  integration_http_method = "POST"
  integration_type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

# /health
resource "aws_api_gateway_method" "get_health" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "GET"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.get_health.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

# /articles
resource "aws_api_gateway_method" "articles_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.articles.id
  http_method   = "GET"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "articles_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.articles.id
  http_method = aws_api_gateway_method.articles_get.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

# /climate-articles
resource "aws_api_gateway_method" "climate_articles_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.climate_articles.id
  http_method   = "GET"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "climate_articles_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.climate_articles.id
  http_method = aws_api_gateway_method.climate_articles_get.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "climate_articles_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.climate_articles.id
  http_method   = "OPTIONS"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "climate_articles_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.climate_articles.id
  http_method = aws_api_gateway_method.climate_articles_options.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}   

# /emails
resource "aws_api_gateway_method" "emails_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.emails.id
  http_method   = "GET"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "emails_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.emails.id
  http_method = aws_api_gateway_method.emails_get.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "emails_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.emails.id
  http_method   = "OPTIONS"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "emails_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.emails.id
  http_method = aws_api_gateway_method.emails_options.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

# /message
resource "aws_api_gateway_method" "message_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.message.id
  http_method   = "GET"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "message_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = aws_api_gateway_method.message_get.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "message_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.message.id
  http_method   = "OPTIONS"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "message_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = aws_api_gateway_method.message_options.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "message_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.message.id
  http_method   = "POST"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "message_post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = aws_api_gateway_method.message_post.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

# /post
resource "aws_api_gateway_method" "post_delete" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.post.id
  http_method   = "DELETE"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "post_delete" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.post.id
  http_method = aws_api_gateway_method.post_delete.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "post_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.post.id
  http_method   = "GET"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "post_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.post.id
  http_method = aws_api_gateway_method.post_get.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "post_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.post.id
  http_method   = "OPTIONS"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "post_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.post.id
  http_method = aws_api_gateway_method.post_options.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "post_patch" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.post.id
  http_method   = "PATCH"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "post_patch" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.post.id
  http_method = aws_api_gateway_method.post_patch.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "post_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.post.id
  http_method   = "POST"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "post_post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.post.id
  http_method = aws_api_gateway_method.post_post.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

# /posts
resource "aws_api_gateway_method" "posts_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.posts.id
  http_method   = "GET"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "posts_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.posts.id
  http_method = aws_api_gateway_method.posts_get.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "posts_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.posts.id
  http_method   = "OPTIONS"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "posts_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.posts.id
  http_method = aws_api_gateway_method.posts_options.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

# /signup
resource "aws_api_gateway_method" "signup_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.signup.id
  http_method   = "OPTIONS"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "signup_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.signup.id
  http_method = aws_api_gateway_method.signup_options.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "signup_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.signup.id
  http_method   = "POST"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "signup_post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.signup.id
  http_method = aws_api_gateway_method.signup_post.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

# /tech-articles
resource "aws_api_gateway_method" "tech_articles_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.tech_articles.id
  http_method   = "GET"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "tech_articles_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.tech_articles.id
  http_method = aws_api_gateway_method.tech_articles_get.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_method" "tech_articles_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.tech_articles.id
  http_method   = "OPTIONS"
  authorization = local.authorization
}

resource "aws_api_gateway_integration" "tech_articles_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.tech_articles.id
  http_method = aws_api_gateway_method.tech_articles_options.http_method

  integration_http_method = local.integration_http_method
  type                    = local.integration_type
  uri                     = local.uri
}

resource "aws_api_gateway_deployment" "main" {
  depends_on  = [aws_api_gateway_integration.main]

  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"
}
