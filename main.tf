provider "aws" {
  region = "eu-north-1"
}

resource "aws_iam_user" "user" {
  name = "Adil.Zhanbek"
}

data "aws_iam_group" "group" {
  group_name = "Admins"
}

resource "aws_iam_user_group_membership" "example" {
  user = aws_iam_user.user.name

  groups = [
    data.aws_iam_group.group.group_name
  ]
}

resource "aws_iam_user_login_profile" "example" {
  user                    = aws_iam_user.user.name
  password_reset_required = true
}

output "password" {
  value     = aws_iam_user_login_profile.example.password
  sensitive = true
}