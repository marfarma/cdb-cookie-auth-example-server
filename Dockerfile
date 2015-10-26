# Copyright 2015 Patricia Pauline Price
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
#

FROM marfarma/couchdb-ssl-node

MAINTAINER Pauli Price pauli.price@gmail.com

# add OS daemon
RUN  apt-get install -y git
RUN  mkdir /usr/bin/auth-daemon
WORKDIR /usr/bin/auth-daemon
RUN  git init && git remote add origin https://github.com/marfarma/couchdb-cookie-auth.git && \
     git config core.sparsecheckout true && \
     echo example/node-server/api >> .git/info/sparse-checkout
RUN  git pull origin master && cd example &&  \
     git checkout
RUN  mv example/node-server/api/* /usr/bin/auth-daemon && \
     rm -rf example && npm install && chmod +x ./api.js

# add node app server config
ADD config.js /usr/bin/auth-daemon/services/config.js

# add couchdb server config
ADD local.ini /usr/local/etc/couchdb/local.ini

RUN  chown -R couchdb:couchdb /usr/bin/auth-daemon
