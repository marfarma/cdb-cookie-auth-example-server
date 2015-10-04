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

FROM klaemo/couchdb

MAINTAINER Pauli Price pauli.price@gmail.com

# install node
RUN apt-get install -y curl
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install --yes nodejs

# add OS daemon
RUN apt-get install -y git
RUN git clone https://github.com/marfarma/couchdb-dbperuser-provisioning.git /usr/bin/couchdb-provision
RUN cd /usr/bin/couchdb-provision && npm install && chmod +x ./lib/provision.js
RUN chown  -R couchdb:couchdb /usr/bin/couchdb-provision

# add couchdb server config
ADD local.ini /usr/local/etc/couchdb/local.ini


