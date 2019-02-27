# beckend config and variables are loaded by the Jenkinsfile
terraform {
  backend "s3" {}
}

variable "creator" {}
variable "repository_name" {}
variable "cost_center" {}
variable "region" {}
variable "owner" {
  default = "no@reply.com"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_ecr_repository" "this" {
  name = "${var.repository_name}"

  tags = {
    Creator        = "${var.creator}"
    CostCenter     = "${var.cost_center}"
    Owner          = "${var.owner}"
  }
}

# add any additional lifecycle or access policies below
# https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
# https://www.terraform.io/docs/providers/aws/r/ecr_repository_policy.html
# https://www.terraform.io/docs/providers/aws/r/ecr_lifecycle_policy.html
