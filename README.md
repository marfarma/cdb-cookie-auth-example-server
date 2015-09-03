## per-user-couchdb

Available in the docker index as marfarma/per-user-couchdb

A CouchDB Docker container pre-configured with a nodejs `os daemon` application that creates a single-user database and server user account from a single proxy request.  It uses the node application, [couchdb-dbperuser-provisioning](https://github.com/pegli/couchdb-dbperuser-provisioning), and is based on klaemo/couchdb.

## Usage

This repository provides an example setup.  To use, fork and update the config file local.ini with your desired values, (see [project documentation](https://github.com/pegli/couchdb-dbperuser-provisioning) for details) and then build a new container.

    docker build -t your_username/your_container_name .

Run the example container with couchdb server on port 80:

    docker run -d --restart=always -p 80:5984 –name couchdb marfarma/per-user-couchdb
  
or, for port 5984:
   
    docker run -d --restart=always -p 5984:5984 –name couchdb marfarma/per-user-couchdb

To use your current directory as the CouchDB Database directory (the log file directory can also be mounted.)


    docker run -d --restart=always -p 5984:5984 -v $(pwd):/usr/local/var/lib/couchdb –name couchdb marfarma/per-user-couchdb

## Provision a new user and database

Make a GET or PUT request to the proxy address on your couchdb server. For example if `_myapp_provision` is the value assigned to the proxy configuration and the username is farnando with password apple, then the provisioning URL would be:

    http://localhost:5984/_myapp_provision?username=fernando&password=apple

## boot2docker

If you're using boot2docker, to access couchdb from your pc, create an ssh tunnel.  For example (depending on exposed port):

    boot2docker ssh -L 80:localhost:80
 
    boot2docker ssh -L 5984:localhost:5984

## Known Issues

Most known issues are limiations of the db per-user provising application.  I plan to submit corresponding pull requests to the upline project as they are fixed.

1. **Pre-existing users not supported** -- an attempt to provision a database for a pre-existing user produces the following error: `{"error":"conflict","reason":"Document update conflict.","info":"create user"}`

1. **User credentials in query string** -- using the query string to pass user credentials is a poor security practice.  Especially so in this example implementation that is not configured for SSL access.  It would be better if the credentials were submitted as part of the post body instead.

1. **Users provisioned with GET requests** -- Get requests to the proxy location of the os daemon should return an error.

1. **No support for multiple applications** -- It is not possible to support more than one application specific database per user.

1. **Dockerfile pulls latest version of the provising application** -- Changes in the upline project could potentially break this implementation.  It would be better to reference a specific revision in the Dockerfile.

1. **Dockerfile pulls latest version of klaemo/couchdb container** -- As with the previous issue, it would be better to reference a specific version.

1. **SSL not implemented** -- An SSL version of the upstream couchdb container exists (klaemo/couchdb-ssl).  It would be best to use SSL if the server is exposed to the internet.

1. **CORS not implemented** -- An existing fork of the provising application supports CORS (https://github.com/awaigand/couchdb-dbperuser-provisioning.git) however it also includes an unwanted change to the per user database naming convention.

1. **Whitelisting not implemented** -- Couchbd supports limiting the config properties that can be accessed via http.  Given admin credentials are stored in plain text, whitelisting should be enabled to prevent accidential exposure.  

1. **Admin credentials as config setting** -- It would be ideal if the credentials were provided to the application via environment variables instead of the config file.

## License

Apache 2.0