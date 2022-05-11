#Bucket for monitoring team
module "report_bucket" {
  source = "../modules/"
  bucket_name = "ziyotek-2021-class-artem-ny-report"
}
#Bucket for ops team
module "datadog_bucket" {
  source = "../modules/"
  bucket_name = "ziyotek-2021-class-artem-ny-datadog"
}
#Bucket for developer team
module "website_bucket" {
  source = "../modules/"
  bucket_name = "ziyotek-2021-class-artem-ny-website"
}



#Provider block
provider "aws" {
  region = "us-east-1"
}
