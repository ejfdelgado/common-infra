resource "google_firestore_database" "default" {
  project     = var.project_name
  name        = "(default)"
  location_id = "us-west2"
  type        = "FIRESTORE_NATIVE"
}