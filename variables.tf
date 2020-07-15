// Variables
variable "project" {
description = "The name of the GCP project."
default = "    "
# example = "my-plex-media-server"
}

variable "region" {
  description = "The region of the GCP project."
  default = "    "
  # example = "europe-west2"
}

variable "zone" {
  description = "The zone of the GCP project."
  default = "    "
  # example = "europe-west2-c"
}

variable "name" {
  description = "The name of the VM instance."
  default = "    "
  # example = "plex-media-server"
}

variable "api-key" {
  description = "The API key."
  default = "    "
  # example = "AIzaSyCkmDOXmks6qbiWSU-Y0ELFIqtv3Jy5xxM"
}