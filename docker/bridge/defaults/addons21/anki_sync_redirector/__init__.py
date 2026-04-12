from __future__ import annotations

import os

import anki.sync
from aqt import gui_hooks, mw


def _normalize_base(url: str | None) -> str | None:
    if not url:
        return None
    return url.rstrip("/") + "/"


def _apply_sync_redirect() -> None:
    base = _normalize_base(os.getenv("ANKI_SYNC_BASE_URL"))
    if not base:
        return

    # Match the custom-sync-server pattern used in the Anki community docs.
    anki.sync.SYNC_BASE = base
    os.environ["SYNC_ENDPOINT"] = base + "sync/"
    os.environ["SYNC_ENDPOINT_MEDIA"] = base + "msync/"


def _reset_host_num() -> None:
    profile = getattr(mw.pm, "profile", None)
    if profile is None:
        return
    profile["hostNum"] = None


_apply_sync_redirect()
gui_hooks.profile_did_open.append(_reset_host_num)
