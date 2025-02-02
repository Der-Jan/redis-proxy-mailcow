#!/bin/sh

cat <<EOF > /redis.conf
requirepass $REDISPASS
port 6379
bind $REDISNETIP
replica-announce-ip $REDISNETIP
EOF

exec redis-server /redis.conf &
exec /redis-sentinel-proxy
