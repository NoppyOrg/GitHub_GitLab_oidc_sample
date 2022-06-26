terraform {
  backend "s3" {
    bucket         = "<CFnで作成したバケットの名前>"
    key            = "development/terraform.tfstate"
    dynamodb_table = "<CFnで作成したDynamoDBのテーブル名>"
    region         = "ap-northeast-1"
  }
}
