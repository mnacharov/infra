resource "google_artifact_registry_repository" "argoproj" {
  location      = var.region
  repository_id = "argoproj"
  description   = "Terraform managed repository for contributions to github.com/argoproj"
  format        = "DOCKER"
}
