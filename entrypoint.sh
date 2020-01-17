#!/bin/bash

# This won't be executed if keys already exist (i.e. from a volume)
ssh-keygen -A

# Copy authorized keys from ENV variable
#echo "$AUTHORIZED_KEYS" >$AUTHORIZED_KEYS_FILE

touch /authorized_keys
cp /keys/authorized_keys_deployer /authorized_keys
chown $OWNER /authorized_keys
chmod 0600 /authorized_keys

# Prevent the user from changing directory upwards
#sed -i -e '/chrootpath/d' /etc/rssh.conf
#echo "chrootpath = $DATADIR" >> /etc/rssh.conf

groupmod --non-unique --gid "$GROUPID" data
usermod --non-unique --home "$DATADIR" --shell /usr/bin/rssh --uid "$USERID" --gid "$GROUPID" "$OWNER"
# Chown data folder (if mounted as a volume for the first time)
chown "${OWNER}:data" "$DATADIR"
chown "${OWNER}:data" $AUTHORIZED_KEYS_FILE

# Run sshd on container start
exec /usr/sbin/sshd -D -e