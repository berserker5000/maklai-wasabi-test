variable "profile" {
  type        = string
  description = "AWS profile to use for the deployment."
  default     = "default"
}
variable "region" {
  type        = string
  description = "AWS region to deploy resources to."
  default     = "us-east-1"
}
variable "users" {
  type        = list(string)
  description = "A list of users to create on an account."
  default     = ["alice", "bob", "charlie", "backup"]
}
variable "buckets" {
  type        = any
  description = "Map of buckets and users/permissions for the bucket to be assigned."
}
