#ReadOnly policy document
data "aws_iam_policy_document" "ro_policy_doc" {
  for_each = var.buckets

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.data_buckets[each.key].arn,
      "${aws_s3_bucket.data_buckets[each.key].arn}/*"
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
      aws_s3_bucket.data_buckets[each.key].arn,
      "${aws_s3_bucket.data_buckets[each.key].arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [for user in each.value.rw_users : aws_iam_user.users[user].arn]
    }
  }
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  for_each = var.buckets

  statement {
    sid    = "denyInsecureTransport"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.data_buckets[each.key].arn,
      "${aws_s3_bucket.data_buckets[each.key].arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}

data "aws_iam_policy_document" "require_latest_tls" {
  for_each = var.buckets

  statement {
    sid    = "denyOutdatedTLS"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.data_buckets[each.key].arn,
      "${aws_s3_bucket.data_buckets[each.key].arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values = [
        "1.2"
      ]
    }
  }
}

#Combined policy document
data "aws_iam_policy_document" "combined_policy_doc" {
  for_each = var.buckets

  source_policy_documents = [
    data.aws_iam_policy_document.ro_policy_doc[each.key].json,
    data.aws_iam_policy_document.rw_policy_doc[each.key].json,
    data.aws_iam_policy_document.require_latest_tls[each.key].json,
    data.aws_iam_policy_document.deny_insecure_transport[each.key].json
  ]
}

#Create policy for users
data "aws_iam_policy_document" "user_policy" {
  for_each = toset(var.users)

  dynamic "statement" {
    for_each = [for bucket_name, bucket in var.buckets :
      "${aws_s3_bucket.data_buckets[bucket_name].arn}/*"
      if contains(bucket.ro_users, each.key)
    ]

    content {
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = [statement.value]
    }
  }

  dynamic "statement" {
    for_each = [for bucket_name, bucket in var.buckets :
      "${aws_s3_bucket.data_buckets[bucket_name].arn}/*"
      if contains(bucket.rw_users, each.key)
    ]

    content {
      effect    = "Allow"
      actions   = ["s3:*"]
      resources = [statement.value]
    }
  }
}

