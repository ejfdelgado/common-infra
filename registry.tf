
resource "google_project_service" "artifact_registry" {
  service = "artifactregistry.googleapis.com"
}

resource "google_artifact_registry_repository" "docker_repo" {
  count = var.environment == "pro" ? 1 : 0
  provider  = google
  location  = "us-central1"
  repository_id = "ejfexperiments"
  description   = "Docker repo in us-central1"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}