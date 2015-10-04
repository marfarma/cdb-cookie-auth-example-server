variable "do_token" {}
variable "ssh_keys" {}
variable "key_file" {}
variable "size" {
  default = "4gb"
}
variable "config" {
  default = <<BAR
#cloud-config

write_files:
  - path: /opt/couchbase/var/.README
    owner: core:core
    permissions: 0644
    content: |
      Couchbase /opt/couchbase/var data volume in container mounted here
  - path: /var/lib/cbfs/data/.README
    owner: core:core
    permissions: 0644
    content: |
      CBFS files are stored here
coreos:
  units:
  - name: docker.service
    command: restart
BAR
}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "coreos3" {
	depends_on = ["digitalocean_droplet.coreos1", "digitalocean_droplet.coreos2"]
  name = "coreos3"
  image = "coreos-alpha"
  private_networking = true
  region = "nyc3"
  size = "${var.size}"
  ssh_keys = ["${var.ssh_keys}"]
	user_data = "${var.config}"

  connection {
		host = "${digitalocean_droplet.coreos3.ipv4_address}"
    user = "core"
		type = "ssh"
    key_file = "${var.key_file}"
		timeout = "60m"
  }

  provisioner "remote-exec" {
    inline = [
      "docker run -d --restart=always -p 443:6984 –name couchdb marfarma/cdb-cookie-auth-example"
    ]
  }

}

output "address_coreos3" {
  value = "${digitalocean_droplet.coreos3.ipv4_address}"
}
