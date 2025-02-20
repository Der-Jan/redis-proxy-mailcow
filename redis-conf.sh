#!/bin/sh

cat <<EOF > /redis.conf
requirepass $REDISPASS
masterauth $REDISPASS
port 6379
bind $REDISNETIP
replica-announce-ip $REDISNETIP
EOF

exec redis-server /redis.conf &
sleep 5
export SENTINEL="redis-sentinel:26379,$(redis-cli -u "redis://default:$REDISPASS@redis-sentinel:26379/0" --json SENTINEL SENTINELS "$MASTER" | jq -r '[.[]|"\(.ip):\(.port)"]| join(",")')"
exec /redis-sentinel-proxy
