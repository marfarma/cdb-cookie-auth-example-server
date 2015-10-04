# A CouchD

Available in the docker index as marfarma/per-user-remote-auth

A Docker container pre-configured with a CouchDB server and a nodejs `os daemon` app that supports passwordless registration (creating a new user and associated single-user database) and authentication.  It returns both a JWT and an AuthSession cookie, allowing the user to interact directly with the CouchDB server as a logged-in user.

The CouchDB server is configured for secure (https) access, using a self-signed certificate by default.  See [the klaemo/docker-couchdb-ssl documentation](https://github.com/klaemo/docker-couchdb-ssl) details on using your own certificate for production use.

A [Terraform](https://www.terraform.io) script is provided to automatically provision a pre-configured droplet from DigitalOcean.  See the README in the terraform directory for details.

## Current Status

This is currently pre-alpha status, and is not ready for serious use.

## TODO

- [ ] Get new server up in order to enable on-device testing
- [ ] Add minimal support for enable os-daemon status to api.js
- [ ] Test couchdb-cookie-auth against an SSL endpoint
- [ ] Add git sparse checkout instructions to example README
- [ ] Integrate the setup CORS npm module as a library for the example server
- [ ] Add comment about the relationship to the couchdb-cookie-auth example app


## Usage

This repository provides an example setup.  To use, fork and update the config file local.ini with your desired values, (see [project documentation](https://github.com/pegli/couchdb-dbperuser-provisioning) for details) and then build a new container.

    docker build -t your_username/your_container_name .

Run the example container with couchdb server on port 443:

    docker run -d --restart=always -p 443:6984 –name couchdb marfarma/cdb-cookie-auth-example

or, for port 6984:

    docker run -d --restart=always -p 6984:6984 –name couchdb marfarma/cdb-cookie-auth-example

To use your current directory as the CouchDB Database directory (the log file directory can also be mounted.)


    docker run -d --restart=always -p 5984:5984 -v $(pwd):/usr/local/var/lib/couchdb –name couchdb marfarma/per-user-couchdb

[](COMMENT: pass environment variables into docker like this: `--env-file ./env.list` expects each line to be in the VAR=VAL format or, if you don't want to have the value on the command-line where it will be displayed by ps, etc., -e can pull in the value from the current environment if you just give it without the `sudo PASSWORD='foo' docker run  [...] -e PASSWORD [...]`)


## Provision a new user and database

Make a GET or PUT request to the proxy address on your couchdb server. For example if `_myapp_provision` is the value assigned to the proxy configuration and the username is farnando with password apple, then the provisioning URL would be:

    http://localhost:5984/_myapp_provision?username=fernando&password=apple

## boot2docker

If you're using boot2docker, to access couchdb from your pc, create an ssh tunnel.  For example (depending on exposed port):

    boot2docker ssh -L 80:localhost:80

    boot2docker ssh -L 5984:localhost:5984

## Credits

This project makes use of, or was inspired by, the following open source projects projects.

1. [couchdb-dbperuser-provisioning](https://github.com/pegli/couchdb-dbperuser-provisioning)
1. [klaemo/docker-couchdb-ssl](https://github.com/klaemo/docker-couchdb-ssl)
1. [add-cors-to-couchdb](https://github.com/pouchdb/add-cors-to-couchdb)

## License

Apache 2.0
