# Redis Sentinel and Replication Setup

This repository contains the necessary files to set up Redis Sentinel and Redis replication for mailcow.

## Files

- `docker-compose.override.yml`: Add this to your mailcow Docker Compose override file for setting up Redis Sentinel and Redis replication
- `Dockerfile`: Dockerfile for building the Redis image with Sentinel and replication support.
- `redis-conf.sh`: Shell script for configuring Redis and starting the Redis Sentinel proxy.

## Setup

### Step 1: Setup sentinel.conf

For each sentinel (3 is minimum required) a conf file needs to be setup in data/conf/sentinel/sentinel.conf.
The $REDISNETIP variable should be the same for each sentinel - as the master is identified by ip (even if the sentinels are in a different network).

```# sentinel.conf
port 26379
logfile ""

bind ${REDISNETWORK:-172.16.35}.3

sentinel announce-ip "${REDISNETWORK:-172.16.35}.3"
sentinel auth-pass $MASTER $REDISPASS
sentinel monitor $MASTER $REDISNETIP 6379 2
```

### Step 2: Setup replication

Connect via redis-cli to your designated redis replica and setup replication (choose as ip for the master the one used in sentinel.conf):
```
docker compose exec redis-mailcow redis-cli -u "redis://default:${REDISPASS}@${REDISNETIP}:6379/0" REPLICAOF 172.16.36.2 6379
```