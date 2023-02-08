# [mnacharov/argo-cd](https://github.com/mnacharov/argo-cd)
resource "google_cloudbuild_trigger" "argocd" {
  project            = var.project_id
  name               = "argocd"
  description        = "Build ArgoCD Image"
  location           = var.region

  github {
    owner = "mnacharov"
    name  = "argo-cd"
    push {
      tag = "v[.0-9]*"
    }
  }

  substitutions = {
    _BUILD_TAG   = "$TAG_NAME"
  }

  service_account = google_service_account.cloudbuild.id
  build {
    logs_bucket = "gs://mnacharov-cloudbuild/logs"

    step {
      name = "gcr.io/kaniko-project/executor:v1.9.1"
      args = ["--dockerfile=Dockerfile", "--destination=us-central1-docker.pkg.dev/${var.project_id}/argoproj/argocd:$${_BUILD_TAG}", "--cache"]
    }

    options {
      dynamic_substitutions = true
    }
    timeout = "6000s"
  }
}

# service account to use in trigger builds
resource "google_service_account" "cloudbuild" {
  project      = var.project_id
  account_id   = "tf-cloudbuild"
  display_name = "Terraform-managed cloudbuild service account"
}
# allow pushing to us-central1-docker.pkg.dev/${var.project_id}/argoproj
resource "google_artifact_registry_repository_iam_member" "cloudbuild_artifactregistry_writer" {
  project    = google_artifact_registry_repository.argoproj.project
  location   = google_artifact_registry_repository.argoproj.location
  repository = google_artifact_registry_repository.argoproj.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.cloudbuild.email}"
}

resource "google_storage_bucket_iam_member" "mnacharov_cloudbuild" {
  bucket = google_storage_bucket.mnacharov_cloudbuild.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.cloudbuild.email}"
}
