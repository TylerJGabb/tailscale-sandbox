terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-9c"
    prefix = "/main"
  }
}

provider "google" {
  project = "dev1-409815"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc" {
  name                    = "terraform-network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "allow_ssh" {
  name      = "terraform-allow-ssh"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000
  source_ranges = [
    "0.0.0.0/0"
  ]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}

//create one subnet in us-central1 region
resource "google_compute_subnetwork" "subnet" {
  name          = "terraform-subnet"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}

//create a compute instance in us-central1 region on the subnet
resource "google_compute_instance" "vm_instance" {
  name                    = "terraform-instance"
  machine_type            = "f1-micro"
  zone                    = "us-central1-c"
  metadata_startup_script = <<-EOF
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install -y nginx
        sudo service nginx start
        EOF

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    # // omit this entire block to create VM without external IP
    # access_config {
    # }
  }
}



