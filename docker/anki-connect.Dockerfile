FROM lscr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

ARG ANKI_VERSION=25.07.5

ENV TITLE=AnkiDesktop
ENV CUSTOM_PORT=3000
ENV DISPLAY=:1
ENV ANKICONNECT_BIND_ADDRESS=0.0.0.0
ENV ANKICONNECT_BIND_PORT=8765
ENV ANKICONNECT_CORS_ORIGIN=http://localhost
ENV ANKICONNECT_CORS_ORIGIN_LIST=*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      git \
      jq \
      unzip \
      zstd \
      ca-certificates \
      libnss3 \
      libxcomposite1 \
      libxdamage1 \
      libxrandr2 \
      libgbm1 \
      libasound2t64 \
      libxkbcommon0 \
      libdrm2 \
      libgtk-3-0 \
      xdg-utils && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/ankitects/anki/releases/download/${ANKI_VERSION}/anki-${ANKI_VERSION}-linux-qt6.tar.zst -o /tmp/anki.tar.zst && \
    mkdir -p /opt/anki && \
    tar --use-compress-program=unzstd -xf /tmp/anki.tar.zst -C /opt/anki --strip-components=1 && \
    rm /tmp/anki.tar.zst

RUN git clone --depth 1 https://github.com/FooSoft/anki-connect.git /tmp/anki-connect && \
    mkdir -p /defaults/addons21/2055492159 && \
    cp -R /tmp/anki-connect/plugin/. /defaults/addons21/2055492159/ && \
    rm -rf /tmp/anki-connect

COPY docker/bridge/defaults/autostart /defaults/autostart
COPY docker/bridge/defaults/ankiconnect-config.json /defaults/ankiconnect-config.json
COPY docker/bridge/defaults/addons21/anki_sync_redirector /defaults/addons21/anki_sync_redirector
COPY docker/bridge/init/50-anki-bridge-init /custom-cont-init.d/50-anki-bridge-init

RUN chmod +x /defaults/autostart /custom-cont-init.d/50-anki-bridge-init

EXPOSE 3000 8765
