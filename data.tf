#ReadOnly policy document
data "aws_iam_policy_document" "ro_policy_doc" {
  for_each = var.buckets

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.data_buckets[each.key].id}",
      "arn:aws:s3:::${aws_s3_bucket.data_buckets[each.key].id}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [for user in each.value.ro_users : aws_iam_user.users[user].arn]
    }
  }
}

#ReadWrite policy document
data "aws_iam_policy_document" "rw_policy_doc" {
  for_each = var.buckets

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.data_buckets[each.key].id}",
      "arn:aws:s3:::${aws_s3_bucket.data_buckets[each.key].id}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [for user in each.value.rw_users : aws_iam_user.users[user].arn]
    }
  }
}

#Combined policy document
data "aws_iam_policy_document" "combined_policy_doc" {
  for_each = var.buckets

  source_policy_documents = [
    data.aws_iam_policy_document.ro_policy_doc[each.key].json,
    data.aws_iam_policy_document.rw_policy_doc[each.key].json
  ]
}