FROM ubuntu:trusty

LABEL MAINTAINER="lgnap"

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update && apt-get -y install \
	supervisor \
	postfix \
	sasl2-bin \
	&& rm -rf /var/lib/apt/lists/*

# Add files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD postfix.sh /opt/postfix.sh
ADD entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]
# Run
CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
