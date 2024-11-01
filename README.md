# maklai-wasabi-test
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.74.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_user.users](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/iam_user) | resource |
| [aws_s3_bucket.data_buckets](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.combined_policy](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.combined_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ro_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rw_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Map of buckets and users/permissions for the bucket to be assigned. | `any` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS profile to use for the deployment. | `string` | `"default"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy resources to. | `string` | `"us-east-1"` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of users to create on an account. | `list(string)` | <pre>[<br/>  "alice",<br/>  "bob",<br/>  "charlie",<br/>  "backup"<br/>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->