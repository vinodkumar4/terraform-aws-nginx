output "bucket" {
  value = aws_s3_bucket.bucket
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "id" {
  value = aws_s3_bucket.bucket.id
}

output "arn" {
  value = aws_s3_bucket.bucket.arn
}
