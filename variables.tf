// Variables
variable "project" {
description = "The name of the GCP project."
default = "my-plex-media-server"
}

variable "region" {
  description = "The region of the GCP project."
  default = "europe-west2"
}

variable "zone" {
  description = "The zone of the GCP project."
  default = "europe-west2-c"
}

variable "name" {
  description = "The name of the VM instance."
  default = "plex-media-server"
}