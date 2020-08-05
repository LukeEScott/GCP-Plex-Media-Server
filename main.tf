provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

 terraform {
    backend "gcs" {
      bucket  = "plex-terraform-state"
      prefix  = "terraform/state"
    }
  }

# COMPUTE ENGINE
resource "google_compute_instance" "plex" {
  name         = "plex-media-server"
  machine_type = "g1-small"
  zone         = var.zone

  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      type = "pd-standard"
      size = "10"
    }
  }

  network_interface {
    network = "default"

    access_config {
    nat_ip = google_compute_address.static.address
    network_tier = "STANDARD"
    }
  }
  
   metadata = {
    ssh-keys = file("ssh-key.txt")
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  labels = {
      owner = "terraform"
  }
}

#EXTERNAL IP

resource "google_compute_address" "static" {
  name = "ipv4-address"
  network_tier = "STANDARD"
}

#FIREWALL RULES
  resource "google_compute_firewall" "https" {
    name    = "default-allow-https"
    network = "default"

    allow {
      protocol = "tcp"
      ports    = ["443","32400"]
    }

    target_tags   = ["https-server"]
    source_ranges = ["0.0.0.0/0"]

  }

  resource "google_compute_firewall" "http" {
    name    = "default-allow-http"
    network = "default"

    allow {
      protocol = "tcp"
      ports    = ["80", "32400"]
    }

    target_tags   = ["http-server"]
    source_ranges = ["0.0.0.0/0"]

  }

#SERVICE ACCOUNT

resource "google_service_account" "cloud_scheduler" {
  account_id   = "cloud-scheduler"
  display_name = "Cloud Scheduler Service Account"
}

resource "google_project_iam_binding" "cloud_scheduler" {
  project = var.project
  role    = "roles/cloudscheduler.jobRunner"
  members = [
    "serviceAccount:${google_service_account.cloud_scheduler.email}"
  ]
}

resource "google_project_iam_binding" "compute_instance" {
  project = var.project
  role    = "roles/compute.instanceAdmin.v1"
  members = [
    "serviceAccount:${google_service_account.cloud_scheduler.email}"
  ]
}

#CLOUD SCHEDULER

resource "google_cloud_scheduler_job" "start_job" {
  name             = "Start-VM"
  description      = "This job will start the plex-media-server VM at 8.05am weekdays."
  schedule         = "5 8 * * *"
  time_zone        = "Europe/London"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = "https://compute.googleapis.com/compute/v1/projects/${var.project}/zones/europe-west2-c/instances/${var.name}/start?key=${var.api-key}%20HTTP/1.1"

  oauth_token {
      service_account_email = google_service_account.cloud_scheduler.email
   }
  }
}

resource "google_cloud_scheduler_job" "stop_job" {
  name             = "Shutdown-VM"
  description      = "This job will shutdown the plex-media-server VM at midnight weekdays."
  schedule         = "0 2 * * *"
  time_zone        = "Europe/London"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = "https://compute.googleapis.com/compute/v1/projects/${var.project}/zones/europe-west2-c/instances/${var.name}/stop?key=${var.api-key}%20HTTP/1.1"

  oauth_token {
      service_account_email = google_service_account.cloud_scheduler.email
   }
  }
}