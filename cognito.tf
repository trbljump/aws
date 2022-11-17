resource "aws_cognito_user_pool" "test" {
    name = "tfpool"
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.test.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email"
    client_id        = "46385509903-8ettjag5l2nuuus2od3vl2o1u7snsre3.apps.googleusercontent.com"
    client_secret    = "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"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_user_pool_domain" "test" {
  domain       = "jmpool2"
  user_pool_id = aws_cognito_user_pool.test.id
}



resource "aws_cognito_user_pool_client" "test" {
  name                                 = "newflask"
  generate_secret                      = true
  user_pool_id                         = aws_cognito_user_pool.test.id
  callback_urls                        = ["https://openidconnect.net/callback"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO", aws_cognito_identity_provider.google.provider_name]
}

output "oidc_client_secret" {
    value = aws_cognito_user_pool_client.test.client_secret
    sensitive = true
}

output "oidc_client_id" {
    value = aws_cognito_user_pool_client.test.id
}

output "cognito_url" {
    value = aws_cognito_user_pool.test.endpoint
}

output "cognito_domain" {
    value = aws_cognito_user_pool_domain.test.domain
}