terraform {
  backend "s3" {
    bucket = "monese-task-terraform-state"
    region = "eu-central-1"
    key    = "monese/"

  }
}