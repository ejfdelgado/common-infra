terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50.0" # Use version 4.50.0 or later
    }
  }
}

provider "google" {
  project = var.project_name
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_name
  region  = var.region
}