FROM neo4j:4.4
MAINTAINER Christopher Mühl "christopher.muehl@hausgold.de"

USER root

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=neo4j.local

# Install system packages
RUN apt-get update -yqqq && \
  apt-get install -y \
    dbus avahi-daemon avahi-utils libnss-mdns haproxy supervisor

# Copy avahi.sh
COPY config/avahi.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/avahi.sh

# Configure haproxy
COPY config/haproxy.conf /etc/haproxy/haproxy.cfg

# Reconfigure supervisord
RUN chown neo4j:neo4j /var/log/supervisor
RUN sed \
    -e 's/\[unix_http_server\]/;[unix_http_server]\n;chown=neo4j:neo4j/' \
    -i /etc/supervisor/supervisord.conf
RUN sed \
    -e 's#file=/var/run/supervisor.sock##' \
    -i /etc/supervisor/supervisord.conf
RUN sed \
    -e 's#chmod=0700##' \
    -i /etc/supervisor/supervisord.conf
RUN sed \
    -e 's/\[supervisord\]/[supervisord]\nuser=neo4j/' \
    -i /etc/supervisor/supervisord.conf

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/

# Run supervisor as root
# TODO: This is stupid. The entrypoint changes the user to neo4j
# if root is set.
USER root

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
