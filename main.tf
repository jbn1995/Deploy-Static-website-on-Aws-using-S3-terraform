resource "random_id" "rand_id" {
    byte_length = 5
}
resource "aws_s3_bucket" "webbucket95" {
    bucket = "webbucket95-${random_id.rand_id.hex}"   
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.webbucket95.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.webbucket95.id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action":  "s3:GetObject",
            "Resource": "${aws_s3_bucket.webbucket95.arn}/*"
        }
    ]
  }
  EOF
}
resource "aws_s3_bucket_website_configuration" "webbucket" {
  bucket = aws_s3_bucket.webbucket95.id
  index_document {
    suffix = "index.html"
  }
}
resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.webbucket95.bucket
    source = "./index.html"
    key = "index.html"
    content_type = "text/html"
}
resource "aws_s3_object" "style" {
    bucket = aws_s3_bucket.webbucket95.bucket
    source = "./styles.css"
    key = "styles.css"
    content_type = "text/css"
}
output "name" {
    value = aws_s3_bucket_website_configuration.webbucket.website_endpoint
}

