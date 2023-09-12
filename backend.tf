terraform {
  backend "s3" {
    bucket = "sctp-ce3-tfstate-bucket-1"
    key    = "jazeel-static-web.tfstate"
    region = "us-east-1"
  }
}
