FROM neo4j:5.3
LABEL org.opencontainers.image.authors="containers@hausgold.de"

# Replace the original entrypoint from the official image
ENTRYPOINT []

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=neo4j.local

# Debian bullseye reached its end of life (2026-08-31) and its packages
# were moved to the archive mirror, so we point apt there first
RUN sed -i \
  -e 's|deb.debian.org/debian-security|archive.debian.org/debian-security|' \
  -e 's|deb.debian.org/debian|archive.debian.org/debian|' \
  /etc/apt/sources.list

# Install system packages
RUN apt-get update -yqqq && \
  apt-get install -y \
    dbus avahi-daemon avahi-utils libnss-mdns haproxy supervisor \
    openssh-server

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure haproxy
COPY config/haproxy.conf /etc/haproxy/haproxy.cfg

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/
RUN mkdir -p /var/log/supervisor

# Define the command to run per default
CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]
