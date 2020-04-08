FROM ubuntu:trusty

LABEL MAINTAINER="lgnap"

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update && apt-get -y install \
	supervisor \
	opendkim \
	opendkim-tools \
	&& rm -rf /var/lib/apt/lists/*

COPY opendkim.conf /etc/opendkim.conf
COPY default_opendkim /etc/default/opendkim
COPY TrustedHosts /etc/opendkim/TrustedHosts

# Add files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD logstdout.sh /opt/logstdout.sh
ADD logstderr.sh /opt/logstderr.sh

ADD entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

