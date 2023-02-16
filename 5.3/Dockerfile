FROM neo4j:5.3
MAINTAINER Hermann Mayer "hermann.mayer@hausgold.de"

# Replace the original entrypoint from the official image
ENTRYPOINT []

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=neo4j.local

# Install system packages
RUN apt-get update -yqqq && \
  apt-get install -y \
    dbus avahi-daemon avahi-utils libnss-mdns haproxy supervisor

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure haproxy
COPY config/haproxy.conf /etc/haproxy/haproxy.cfg

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/
RUN mkdir -p /var/log/supervisor

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
