resource "random_password" "okta_user1_password" {
  length  = 12
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "random_password" "okta_user2_password" {
  length  = 12
  special = true
  upper   = true
  lower   = true
  numeric = true
}