FROM ubuntu:14.04

ENV CB_VERSION		3.0.3
ENV CB_FILENAME		couchbase-server-enterprise_${CB_VERSION}-ubuntu12.04_amd64.deb
ENV CB_SOURCE 		http://packages.couchbase.com/releases

# Add couchbase binaries to PATH
# ENV PATH $PATH:/opt/couchbase/bin:/opt/couchbase/bin/tools:/opt/couchbase/bin/install

# Install packages dependencies
RUN apt-get update && apt-get -y install \
	wget \
	curl \
	librtmp0 \
	python-pip


# Install couchbase
RUN wget "$CB_SOURCE/$CB_VERSION/$CB_FILENAME" -O "/tmp/$CB_FILENAME" \ 
	&& dpkg -i "/tmp/$CB_FILENAME"  \
	&& rm "/tmp/$CB_FILENAME"

RUN ln -s /opt/couchbase/bin/couchbase-cli /usr/local/bin/

# Add start script
ADD sources/couchbase-start /usr/local/bin/

RUN mkdir -p /data/ /index

RUN chown couchbase:couchbase /data /index

VOLUME /data

VOLUME /index

EXPOSE 4369 8091 8092 11210 11211

USER root
CMD couchbase-start