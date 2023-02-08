#############################################
# !terraform state location -- do not remove!
resource "google_storage_bucket" "mnacharov_infra" {
  name          = "mnacharov-infra"
  location      = "us-central1"

  public_access_prevention = "enforced"
}
# !terraform state location -- do not remove!
#############################################

