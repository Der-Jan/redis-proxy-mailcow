FROM patrickdk/redis-sentinel-proxy AS proxy

FROM redis:7-alpine AS redis 
COPY --from=proxy /redis-sentinel-proxy /redis-sentinel-proxy
COPY --from=proxy /health /health

COPY redis-conf.sh /redis.sh

HEALTHCHECK --interval=5s --timeout=3s --start-period=15s --retries=3 CMD [ "/health" ]

ENTRYPOINT [ "/redis.sh" ]