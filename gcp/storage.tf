#############################################
# !terraform state location -- do not remove!
resource "google_storage_bucket" "mnacharov_infra" {
  name          = "mnacharov-infra"
  location      = "us-central1"

  public_access_prevention = "enforced"
}
# !terraform state location -- do not remove!
#############################################

resource "google_storage_bucket" "mnacharov_cloudbuild" {
  name          = "mnacharov-cloudbuild"
  location      = "us-central1"

  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}
