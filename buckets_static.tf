resource "google_storage_bucket" "static_site_old" {
  name     = "${var.environment}-ejflab-assets"
  location = "US"
  website {
    #main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  uniform_bucket_level_access = true
  cors {
    origin          = var.cors_allowed
    method          = ["GET", "HEAD", "OPTIONS"]
    response_header = ["Content-Type", "Authorization", "Access-Control-Allow-Origin"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_iam_binding" "public_read_get_only" {
  bucket = google_storage_bucket.static_site_old.name
  role   = "roles/storage.legacyObjectReader"
  members = [
    "allUsers"
  ]
}

resource "google_storage_bucket" "terraform_state" {
  count                       = var.environment == "pro" ? 1 : 0
  name                        = "${var.environment}-ejflab-terraform"
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}