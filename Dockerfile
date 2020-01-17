FROM debian:jessie

ENV DATADIR=/var/www/backend \
  AUTHORIZED_KEYS_FILE=/authorized_keys \
  USERID=33 \
  GROUPID=33 \
  OWNER=data

RUN apt-get update \
 && apt-get install -y openssh-server rssh rsync \
 && rm -f /etc/ssh/ssh_host_* \
 && groupadd --non-unique --gid $GROUPID data \
 && useradd --non-unique --uid $USERID --gid $GROUPID --no-create-home --home-dir $DATADIR --shell /usr/bin/rssh $OWNER \
 && mkdir -p "$DATADIR" \
 && chown $OWNER "$DATADIR" \
 && echo "AuthorizedKeysFile /authorized_keys" >>/etc/ssh/sshd_config \
 && echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1" >>/etc/ssh/sshd_config \
 && mkdir /var/run/sshd && chmod 0755 /var/run/sshd \
 && echo "allowscp" >> /etc/rssh.conf \
 && echo "allowsftp" >> /etc/rssh.conf \
 && echo "allowrsync" >> /etc/rssh.conf

ADD entrypoint.sh /
RUN chmod 0755 /entrypoint.sh

EXPOSE 22

CMD ["/entrypoint.sh"]