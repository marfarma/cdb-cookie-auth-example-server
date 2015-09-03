## couchdb-per-user

Available in the docker index as marfarma/couchdb-per-user

A CouchDB Docker container pre-configured with a nodejs `os daemon` which provisions a single-user database and server user account from a single proxy request.  The container combines the node application, [couchdb-dbperuser-provisioning](https://github.com/pegli/couchdb-dbperuser-provisioning) with the klaemo/couchdb container.

## Usage

This repository provides an example setup.  To use, fork this repo and uppdate local.ini with your desired values, see [project documentation](https://github.com/pegli/couchdb-dbperuser-provisioning) and build a new container.

    docker build -t your_username/per-user-couchdb .

Run the example container with following command to expose couchdb server on port 80 of docker host:

    docker run -d --restart=always -p 80:5984 –name couchdb marfarma/couchdb-per-user
  
or, to exposed it on port 5984, use the following:
   
    docker run -d --restart=always -p 5984:5984 –name couchdb marfarma/couchdb-per-user
  
If you're developing using boot2docker, to access the server from the pc, create a tunnel.  For example (depending on exposed port):

    boot2docker ssh -L 80:localhost:80
 
    boot2docker ssh -L 80:localhost:80

Provision a new user and database as follows - GET or PUT to the following address (_myapp_provision is the user configurable proxy location of the db per-user provising application.  Substitute your own value assigned in the local.ini config file.):

    http://localhost:5984/_myapp_provision?username=fernando&password=apple


## Known Issues

The most of the following known issues are limiations of the db per-user provising application.  I plan to address them and submit corresponding pull requests to the upline project.

1. **Pre-existing users not supported** -- an attempt to provision a database for a pre-existing server produces the following error: `{"error":"conflict","reason":"Document update conflict.","info":"create user"}`

1. **User credentials in query string** -- using the query string to pass user credentials is a poor security practice.  Especially so in this example implementation that is not configured for SSL access.  It would be better if the credentials were submitted as part of the post body instead.

1. **Users provisioned with GET requests** -- Get requests to the proxy location of the os daemon should return an error.

1. **No support for multiple applications** -- It is not possible to support more than one application specific database per user.

1. **Dockerfile pulls latest version of the provising application** -- Changes in the upline project could potentially break this implementation.  It would be better to reference a specific revision in the Dockerfile.

1. **Dockerfile pulls latest version of klaemo/couchdb container** -- As with the previous issue, it would be better to reference a specific version.

1. **SSL not implemented** -- An SSL version of the upstream couchdb container exists (klaemo/couchdb-ssl).  It would be best to use that base container if the server is exposed to the internet.

1. **CORS not implemented** -- An existing fork of the provising application supports CORS (https://github.com/awaigand/couchdb-dbperuser-provisioning.git) however it also includes an unwanted change to the per user database naming convention.

1. **Whitelisting not implemented** -- Couchbd supports limiting the config properties that can be access via http.  Given that the admin credentials are stored in plain text, whitelisting should be enabled to prevent accidential exposure.  

1. **Admin credentials as config setting** -- It would be ideal if the credentials were provided to the application via environment variables instead of via config setting.

## License

Apache 2.0