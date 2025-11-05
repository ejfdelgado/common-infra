
resource "google_storage_bucket" "static_site" {
  name                        = "${var.environment}-${local.bucket_name}"
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
  cors {
    origin = [
      "https://${var.environment}-${local.bucket_name}.storage.googleapis.com",
      "http://${var.environment}-${local.bucket_name}.storage.googleapis.com"
    ]
    method          = ["GET", "HEAD", "OPTIONS"]
    response_header = ["Content-Type", "Authorization", "Access-Control-Allow-Origin"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_iam_member" "static_site_access" {
  bucket = google_storage_bucket.static_site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
