FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV SYNC_BASE=/data/sync
ENV SYNC_HOST=0.0.0.0
ENV SYNC_PORT=8080
ENV RUST_LOG=anki=info

RUN pip install --no-cache-dir anki==25.9.2

RUN useradd --system --uid 65532 --create-home anki

USER 65532:65532
WORKDIR /home/anki

EXPOSE 8080

CMD ["python", "-m", "anki.syncserver"]
