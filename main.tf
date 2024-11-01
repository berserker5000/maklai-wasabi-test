#Create buckets
resource "aws_s3_bucket" "data_buckets" {
  for_each = var.buckets
  bucket   = "${each.key}-data-bucket"
}

#Create users
resource "aws_iam_user" "users" {
  for_each = toset(var.users)
  name     = each.key
}

#Attach policies to buckets
resource "aws_s3_bucket_policy" "combined_policy" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.data_buckets[each.key].id
  policy   = data.aws_iam_policy_document.combined_policy_doc[each.key].json
}
