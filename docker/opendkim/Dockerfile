FROM ubuntu:trusty

LABEL MAINTAINER="lgnap"

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update && apt-get -y install \
	opendkim \
	opendkim-tools \
	&& rm -rf /var/lib/apt/lists/*

# Add files
ADD entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]
# Run
CMD ["/usr/sbin/opendkim", "-f", "-x", "/etc/opendkim.conf" ]
