terraform {
  backend "s3" {
    bucket       = "shopitry-terraform-state"
    key          = "shopitry/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}