#Create buckets
resource "aws_s3_bucket" "data_buckets" {
  for_each = var.buckets
  bucket   = "${each.key}-data-bucket"
}

#Attach policies to buckets
resource "aws_s3_bucket_policy" "combined_policy" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.data_buckets[each.key].id
  policy   = data.aws_iam_policy_document.combined_policy_doc[each.key].json
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.data_buckets[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_iam_policy" "user_bucket_policies" {
  for_each = toset(var.users)

  name        = "${each.key}-bucket-access"
  description = "Access policy for user ${each.key}"

  policy = data.aws_iam_policy_document.user_policy[each.key].json
}


#Create users
resource "aws_iam_user" "users" {
  for_each = toset(var.users)
  name     = each.key
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  depends_on = [aws_iam_user.users]
  for_each   = toset(var.users)

  user       = aws_iam_user.users[each.key].name
  policy_arn = aws_iam_policy.user_bucket_policies[each.key].arn
}