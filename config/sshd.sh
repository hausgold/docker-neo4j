#!/usr/bin/env bash

# We allow to start an SSH server inside the container to enable the
# programmatically access to neo4j tooling. This is disabled by default.
export SSHD_ENABLE=${SSHD_ENABLE:-'false'}
export SSHD_CUSTOM_CONIFG=${SSHD_CUSTOM_CONIFG:-'false'}
export SSHD_ROOT_PASSWORD=${SSHD_ROOT_PASSWORD:-'root'}

# When this feature is disabled, we just do nothing. Forever.
if [ "${SSHD_ENABLE}" != 'true' ]; then
  tail -f /dev/null
  exit $?
fi

# Prepare the environment for dbus
mkdir -p /run/sshd
chmod 0755 /run/sshd

# We allow our users to supply a custom sshd config,
# so we do not overwrite their file contents
if [ "${SSHD_CUSTOM_CONIFG}" = 'false' ]; then
  cat >/etc/ssh/sshd_config <<'EOF'
UsePAM no
PermitRootLogin yes
PasswordAuthentication yes
ChallengeResponseAuthentication no
PermitEmptyPasswords yes
MaxAuthTries 20
StrictModes no
EOF
fi

# Preserve the current environment variables for ssh sessions
env | grep -P '(.+_|PATH)' | sed 's/^/export /g' >> /etc/environment
echo 'source /etc/environment' >> /root/.bashrc

# Change the root password to the configured one
echo "root:${SSHD_ROOT_PASSWORD}" | chpasswd

# Start the ssh daemon
exec /usr/sbin/sshd -D -e
