resource "google_cloud_run_v2_service" "common_backend" {
  name     = "${var.environment}-common-backend"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    #service_account = google_service_account.common_backend_sa.email
    containers {
      image = var.common_backend_image
      env {
        name  = "GOOGLE_CLIENT_ID"
        value = local.secrets.oauth_client_id
      }
      env {
        name  = "CORS_MAIN_ALLOWED_ORIGIN"
        value = "http://localhost:4200 https://localhost:4200"
      }
      env {
        name  = "BUCKET_NAME"
        value = "${var.environment}-ejflab-assets"
      }
      env {
        name  = "LOCAL_FOLDER"
        value = "/tmp"
      }
      env {
        name  = "NODE_ENV"
        value = var.environment
      }

      resources {
        limits = {
          # 512Mi
          memory = "2Gi"
          # '1', '2', '4', and '8' 1000m 250m 500m
          cpu = "1"
        }
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
  # Allow unauthenticated invocations
  traffic {
    type            = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent         = 100
  }

  ingress = "INGRESS_TRAFFIC_ALL"  # Allows all traffic, including unauthenticated
  deletion_protection = false
}

resource "google_cloud_run_service_iam_member" "no_auth" {
  service     = google_cloud_run_v2_service.common_backend.name
  location    = google_cloud_run_v2_service.common_backend.location
  role        = "roles/run.invoker"
  member      = "allUsers"
  depends_on = [google_cloud_run_v2_service.common_backend]
}

resource "google_service_account" "common_backend_sa" {
  account_id   = "${var.environment}-common-backend-sa"
  display_name = "Service account for Express backend"
}

resource "google_storage_bucket_iam_member" "common_backend_admin" {
  bucket = "${var.environment}-ejflab-assets"
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.common_backend_sa.email}"
}

resource "google_project_iam_member" "common_backend_logging" {
  project = var.project_name
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.common_backend_sa.email}"
}