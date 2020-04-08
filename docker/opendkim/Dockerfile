FROM ubuntu:trusty

LABEL MAINTAINER="lgnap"

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update && apt-get -y install \
	opendkim \
	opendkim-tools \
	&& rm -rf /var/lib/apt/lists/*

COPY opendkim.conf /etc/opendkim.conf
COPY default_opendkim /etc/default/opendkim

# Add files
ADD entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Run (config file loaded auto, foreground & socket in config file)
CMD ["/usr/sbin/opendkim"]
