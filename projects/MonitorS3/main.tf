module "monitoring_bucket" {

  source = "../S3"

}


module "report_bucket" {

  source      = "../S3"
  bucket_name = "fall-web-project-artem-report"
}


module "jenkins_bucket" {

  source      = "../S3"
  bucket_name = "fall-web-project-artem-jenkins"
}

module "terraform_bucket" {

  source      = "../S3"
  bucket_name = "fall-web-project-artem-terraform"
}
