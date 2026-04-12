# anki-helm

Private Anki stack with two workloads:

- `anki-sync`: self-hosted sync server
- `anki-connect`: desktop Anki + AnkiConnect

Required secret:

```yaml
anki-sync:
  secretVars:
    SYNC_USER1: "anki-sync/sync-user1"
```

`SYNC_USER1` must be `username:password` unless `PASSWORDS_HASHED=1`.

Inspired by [Anki Desktop Docker](https://github.com/mlcivilengineer/anki-desktop-docker).