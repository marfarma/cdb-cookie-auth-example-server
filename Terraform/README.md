Terraform script to provision an example server with DigitalOcean.

To use this script, you must have:

1. SSL public key registered for use with DigitalOcean, and the id DigitalOcean assigned it.
1. Path to the private key file, corresponding to that public key
1. Client Id and API key provided by DigitalOcean

How to determing your DigitalOcean SSH Key Id

Discover the id associated with your SSH keys with the following API request

    GET https://api.digitalocean.com/v1/ssh_keys/?client_id=[client_id]&api_key=[api_key]

Which should return a json response, similar to this:

    {
      "status": "OK",
      "ssh_keys": [
        {
          "id": 10,
          "name": "office-imac"
        },
        {
          "id": 11,
          "name": "macbook-air"
        }
      ]
    }

Note the id associated with the name of the key you wish to use for provisioning and
update the env.sh file variable SSH_KEY_ID with the value.

### TODO

1. Add support for user_name_format = [encoded|plain]
1. Add DNS setup to the script

        resource "dnsimple_record" "hello" {
          domain = "example.com"
          name = "test"
          value = "${digitalocean_droplet.web.ipv4_address}"
          type = "A"
        }
