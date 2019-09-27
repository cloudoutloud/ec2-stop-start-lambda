# Configure credential AWS Provider

provider "aws" {
    region = "${var.aws_region}"
    shared_credentials_file = "$HOME/.aws/credentials"
    profile = "sandbox"
}
