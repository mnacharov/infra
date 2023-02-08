// Set terraform version
terraform {
  required_version = "~> 1.3.3"
  required_providers {
    google = {
      source  = "google"
      version = "~> 4.45.0"
    }
  }
  backend "gcs" {
    bucket  = "mnacharov-infra"
    prefix  = "gcp"
  }
}

// Configure the Google Cloud provider
provider "google" {
 project = var.project_id
 region  = var.region
}
