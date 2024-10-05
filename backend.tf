terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "enzo-0105"
    workspaces {
      name = "jiggy"
    }
  }
}