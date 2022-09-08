# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  sensitive = true # Requires terraform >= 0.14
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# Create a server
resource "hcloud_firewall" "myfirewall" {
  name = "my-firewall"
  rule {
    direction = "out"
    protocol  = "tcp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

}

resource "hcloud_server" "node1" {
  name         = "node1"
  image        = "debian-9"
  server_type  = "cx11"
  firewall_ids = [hcloud_firewall.myfirewall.id]
}