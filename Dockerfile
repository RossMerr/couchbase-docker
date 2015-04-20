FROM debian:wheezy

ENV CB_VERSION		3.0.3
ENV CB_RELEASE_URL	http://packages.couchbase.com/releases
ENV CB_PACKAGE		couchbase-server-enterprise_3.0.3-ubuntu12.04_amd64.deb

# Add couchbase binaries to PATH
ENV PATH $PATH:/opt/couchbase/bin:/opt/couchbase/bin/tools:/opt/couchbase/bin/install

RUN apt-get update

RUN apt-get install -y \
    hostname \
    initscripts \
    openssl \
    pkgconfig \
    sudo \
    tar \
    wget \
    curl

# Install couchbase
# RUN wget --quiet --output-document=- $CB_RELEASE_URL/$CB_VERSION/$CB_PACKAGE | dpkg --install -
RUN curl -o- $CB_RELEASE_URL/$CB_VERSION/$CB_PACKAGE | dpkg --install 

# Modify /etc/passwd to add a login shell, otherwise running
#    su - couchbase -c "/opt/couchbase/bin/couchbase-server -- -noinput"
# will give an error: 
#    This account is currently not available.
# This is only an issue on Couchbase Server 3.x, and it's a no-op on 2.x
RUN sed -i -e 's/\/opt\/couchbase:\/sbin\/nologin/\/opt\/couchbase:\/bin\/sh/' /etc/passwd

# Add start script
ADD scripts/couchbase-start /usr/local/bin/
