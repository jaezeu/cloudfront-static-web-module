terraform {
  backend "s3" {
    bucket = "sctp-ce4-tfstate-bucket"
    key    = "jazeel-static-web-prd.tfstate" #Remember to change this
    region = "ap-southeast-1"
  }
}
