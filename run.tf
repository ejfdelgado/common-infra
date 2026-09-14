resource "google_cloud_run_v2_service" "common_backend" {
  name     = "${var.environment}-common-backend"
  location = var.region
  template {
    max_instance_request_concurrency = 10
    service_account = google_service_account.common_backend_sa.email
    containers {
      image = var.common_backend_image
      env {
        name  = "GOOGLE_CLIENT_ID"
        value = local.secrets.oauth_client_id
      }
      env {
        name  = "GOOGLE_CLIENT_SECRET"
        value = local.secrets.oauth_client_secret
      }
      env {
        name  = "GOOGLE_REDIRECT_URI"
        value = "https://chat.pais.tv/admin/user/calendar/allow/callback"
      }
      env {
        name  = "CORS_MAIN_ALLOWED_ORIGIN"
        value = join(",", var.cors_allowed)
      }
      env {
        name  = "BUCKET_NAME"
        value = google_storage_bucket.static_site_old.name
      }
      env {
        name  = "LOCAL_FOLDER"
        value = "/mnt/data"
      }
      env {
        name  = "NODE_ENV"
        value = var.environment
      }
      env {
        name  = "FIREBASE_SERVICE_ACCOUNT_PATH"
        value = "/app/credentials/ejfexperiments-fb93b4482458.json"
      }
      env {
        name  = "REDIRECT_DOMAIN"
        value = "https://chat.pais.tv"
      }
      env {
        name  = "LOCAL_PUBLIC_KEY"
        value = local.secrets.local_public_key
      }
      env {
        name  = "LOCAL_PRIVATE_KEY"
        value = local.secrets.local_private_key
      }
      env {
        name  = "DEFAULT_USER_UID"
        value = "ssrUGdrrj2Z5FtI8tt30faY8WWn2"
      }
      env {
        name  = "GEMINI_ssrUGdrrj2Z5FtI8tt30faY8WWn2"
        value = local.secrets.GEMINI_ssrUGdrrj2Z5FtI8tt30faY8WWn2
      }
      env {
        name  = "GEMINI_MODEL"
        value = local.secrets.GEMINI_MODEL
      }
      env {
        name  = "GEMINI_PASS"
        value = local.secrets.GEMINI_PASS
      }
      env {
        name  = "SEND_GRID_VARIABLE"
        value = local.secrets.SEND_GRID_VARIABLE
      }
      env {
        name  = "EMAIL_SENDER"
        value = "info@pais.tv"
      }
      env {
        name  = "EMAIL_CONTACT_US"
        value = "info@pais.tv"
      }
      env {
        name = "SUPABASE_DATABASE_URL"
        value = local.secrets.SUPABASE_DATABASE_URL
      }
      env {
        name = "DEFAULT_OFFLINE_AUTH"
        value = local.secrets.DEFAULT_OFFLINE_AUTH
      }
      

      resources {
        limits = {
          # 512Mi
          memory = "4Gi"
          # '1', '2', '4', and '8' 1000m 250m 500m
          cpu = "1"
        }
      }
      
      volume_mounts {
        name       = "gcs-volume"
        mount_path = "/mnt/data"
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    volumes {
      name = "gcs-volume"
      gcs {
        bucket    = google_storage_bucket.static_site_old.name
        read_only = false
        mount_options = [
          "implicit-dirs",
          "uid=1000",
          "gid=1000"
        ]
      }
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

# The Service Account:

resource "google_service_account" "common_backend_sa" {
  account_id   = "${var.environment}-common-backend-sa"
  display_name = "Service account for Express backend"
}

resource "google_storage_bucket_iam_member" "common_backend_admin" {
  bucket = google_storage_bucket.static_site_old.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.common_backend_sa.email}"
}

resource "google_storage_bucket_iam_member" "common_backend_object_admin" {
  bucket = google_storage_bucket.static_site_old.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.common_backend_sa.email}"
}

resource "google_project_iam_member" "common_backend_logging" {
  project = var.project_name
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.common_backend_sa.email}"
}

resource "google_project_iam_member" "firestore_access" {
  project = var.project_name
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.common_backend_sa.email}"
}

/*
It works because on Domain Service we have:
cname	share	ghs.googlehosted.com.

and, on google cloud we use domain mapping:
https://console.cloud.google.com/run/domains?project=ejfexperiments
*/

resource "google_compute_managed_ssl_certificate" "share" {
  count = var.environment == "pro" ? 1 : 0
  name    = "${var.environment}-share"
  managed {
    domains = ["share.pais.tv."]
  }
}