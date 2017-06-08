#!/usr/bin/dumb-init /bin/sh

uid=${CONSUL_UID:-1000}

# check if a old consul user exists and delete it
cat /etc/passwd | grep consul
if [ $? -eq 0 ]; then
    deluser consul
fi

# (re)add the consul user
adduser -D -g '' -u ${uid} -h /home/consul consul

# chown home and data folder
chown -R consul /home/consul /config /data

su-exec consul "$@"
