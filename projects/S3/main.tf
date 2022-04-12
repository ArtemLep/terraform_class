#Create S3 bucket
resource "aws_s3_bucket" "project-s3-bucket" {
  bucket = var.bucket_name
  force_destroy = true #NOT recomended
}
#S3 policy attach
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.project-s3-bucket.id
  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
EOF
}
# S3 bucket ACL
resource "aws_s3_bucket_public_access_block" "public_acl" {
  block_public_acls   = false
  block_public_policy = false
  bucket              = aws_s3_bucket.project-s3-bucket.id
}
#S3 Bucket versioning enable
resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.project-s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#S3 static website configuration
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.project-s3-bucket.bucket

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}