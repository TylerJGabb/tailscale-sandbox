variable "AUTH_KEY" {
  type = string
}

resource "google_compute_instance" "tf_tailscale_subnet_router" {
  name           = "tf-tailscale-subnet-router"
  machine_type   = "f1-micro"
  zone           = "us-central1-c"
  tags           = ["tailscale"]
  can_ip_forward = true
  depends_on     = [google_compute_router_nat.nat]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
  }
  # logs located at /var/log/daemon.log
  metadata_startup_script = <<-EOF
        curl -fsSL https://tailscale.com/install.sh | sh;
        echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward;
        sudo tailscale up --authkey ${var.AUTH_KEY} --advertise-routes=${google_compute_subnetwork.subnet.ip_cidr_range} --accept-dns=false;
    EOF

}
