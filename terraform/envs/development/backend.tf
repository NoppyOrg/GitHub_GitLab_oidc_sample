terraform {
  backend "s3" {
    bucket         = "terraformbase-backend-h4d53v95hxg5"
    key            = "development/terraform.tfstate"
    dynamodb_table = "terraform-lock-state-table"
    region         = "ap-northeast-1"
  }
}
