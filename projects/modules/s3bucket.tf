#Create S3 bucket
resource "aws_s3_bucket" "project-s3-bucket" {
  bucket        = var.bucket_name
  force_destroy = true #NOT recomended
}

variable "bucket_name" {
  type    = string
  default = "ziyotek-2021-class-artem-ny"
}
