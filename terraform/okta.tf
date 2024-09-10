resource "okta_app_oauth" "sample_oidc_app" {
  label       = "Sample OIDC App"
  type        = "web"
  grant_types = ["authorization_code"]

  redirect_uris = [
    "http://${azurerm_public_ip.vinted_public_ip.ip_address}:3000/callback"
  ]

  response_types = ["code"]
  implicit_assignment = true
  consent_method = "REQUIRED"

}
resource "okta_user" "vinted_okta_user1" {
  first_name = "John"
  last_name  = "Smith"
  login      = "john@smith.com"
  email      = "john@smith.com"
  password   = random_password.okta_user1_password.result
}

resource "okta_user" "vinted_okta_user2" {
  first_name = "Joe"
  last_name  = "doe"
  login      = "joe@doe.com"
  email      = "joe@doe.com"
  password   = random_password.okta_user2_password.result
}
