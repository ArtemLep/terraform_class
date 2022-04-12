# I am creating dev users
resource "aws_iam_user" "dev-users" {
  count = length(var.dev-users)
  name  = element(var.dev-users, count.index)
}
resource "aws_iam_user" "test-users" {
  count = length(var.test-users)
  name  = element(var.test-users, count.index)
}
resource "aws_iam_user" "prod-users" {
  count = length(var.prod-users)
  name  = element(var.prod-users, count.index)
}
# I am creating IAM group
resource "aws_iam_group" "dev-group" {
  name = "development"
}
resource "aws_iam_group" "test-group" {
  name = "tester"
}
resource "aws_iam_group" "prod-group" {
  name = "production"
}
# Assign "dev-users -> dev-group"
resource "aws_iam_group_membership" "dev-user-group" {
  name = "dev-user-group"
  count = length(var.dev-users)
  users = [
    element(aws_iam_user.dev-users.*.name, count.index)
  ]
  group = aws_iam_group.dev-group.name
}
# Assign "test-users -> test-group"
resource "aws_iam_group_membership" "test-user-group" {
  name = "test-user-group"
  count = length(var.test-users)
  users = [
    element(aws_iam_user.test-users.*.name, count.index)
  ]
  group = aws_iam_group.test-group.name
}
#Assign "prod-users -> prod-group"
resource "aws_iam_group_membership" "prod-user-group" {
  name = "prod-user-group"
  count = length(var.prod-users)
  users = [
    element(aws_iam_user.prod-users.*.name, count.index)
  ]
  group = aws_iam_group.prod-group.name
}



