variable "bucket_name" {
  description = "Optional. The exact name of the bucket. Must be globally unique or it will fail!"
  default     = null
}

variable "bucket_prefix" {
  description = "Optional. Name prefix of the bucket"
  default     = null
}

variable "acceleration_status" {
  description = "Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  default     = "Suspended"

  validation {
    condition     = var.acceleration_status == "Enabled" || var.acceleration_status == "Suspended"
    error_message = "Invalid Acceleration Status! Must be 'Enabled' or 'Suspended'."
  }
}

variable "acl" {
  description = "The canned ACL to apply. https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl"
  default     = "private"
}

variable "force_destroy" {
  description = "Allow a bucket to be delete even if there are objects in the bucket"
  default     = false
}

variable "enable_versioning" {
  description = "Enable object versioning"
  default     = false
}

variable "server_side_encryption_configuration" {
  description = "Service side encryption configuration"
  default     = []

  type = list(object({
    kms_master_key_id = string
    sse_algorithm     = string
  }))
}

variable "grant" {
  description = "Access control list policy grants"
  default     = []

  type = list(object({
    id          = string
    type        = string
    permissions = list(string)
    uri         = string
  }))
}

variable "lifecycle_rules" {
  description = "A configuration of object lifecycle management"
  default     = []

  type = list(object({
    id      = string
    prefix  = string
    enabled = bool

    abort_incomplete_multipart_upload_days = number

    expiration = list(object({
      days                         = number
      expired_object_delete_marker = bool
    }))

    transition = list(object({
      days          = number
      storage_class = string
    }))

    noncurrent_version_transition = list(object({
      days          = number
      storage_class = string
    }))

    noncurrent_version_expiration = list(object({
      days = number
    }))
  }))
}

