FROM rust:1.85.0-alpine3.20 AS builder

ARG ANKI_VERSION=25.09.2

RUN apk update && apk add --no-cache build-base protobuf && rm -rf /var/cache/apk/*

RUN cargo install --git https://github.com/ankitects/anki.git \
  --tag ${ANKI_VERSION} \
  --root /anki-server \
  --locked \
  anki-sync-server

FROM alpine:3.21.0

ENV PUID=1000
ENV PGID=1000
ENV SYNC_BASE=/data/sync
ENV SYNC_HOST=0.0.0.0
ENV SYNC_PORT=8080
ENV RUST_LOG=anki=info

COPY --from=builder /anki-server/bin/anki-sync-server /usr/local/bin/anki-sync-server

RUN apk update && apk add --no-cache bash su-exec wget && rm -rf /var/cache/apk/*

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/health || exit 1

CMD ["anki-sync-server"]
