terraform {
  backend "gcs" {
    prefix = "terraform/nogales-infra-initial/state"
  }
}
