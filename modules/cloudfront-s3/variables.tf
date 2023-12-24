variable "env" {
  type    = string
  default = ""
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM cert ARN"
}

variable "aliases" {
  type        = list(any)
  description = "Alternate domain names"
  default     = []
}