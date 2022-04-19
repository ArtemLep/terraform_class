variable "cidrs" {
  type    = list(any)
  default = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "av_zones" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b"]
}