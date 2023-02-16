FROM neo4j:4.4
MAINTAINER Christopher Mühl "christopher.muehl@hausgold.de"

# Replace the original entrypoint from the official image
ENTRYPOINT []

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=neo4j.local
ENV OLD_APOC_URL='https://github.com/neo4j/apoc/blob/master/versions.json'
ENV NEW_APOC_URL='https://neo4j-contrib.github.io/neo4j-apoc-procedures/versions.json'

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

# Correct the APOC extensions download URIs
# See: https://github.com/neo4j/apoc/issues/271
RUN sed -i "s#${OLD_APOC_URL}#${NEW_APOC_URL}#g" \
  /startup/neo4jlabs-plugins.json

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
