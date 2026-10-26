# Architecture

```
Flutter app (frontend/)  --HTTP-->  Local AI server (backend/local_ai_server.py, port 8080)
                                      |-- POST /asr        speech -> Hindi text  (IndicConformer, NeMo)
                                      |-- POST /translate  Hindi -> Santali Ol Chiki (IndicTrans2)
                                      |-- POST /tts        Santali text -> speech (Quipus + SNAC)
                                      '-- GET  /status     health check
```

The app tries these server URLs in order (see `frontend/lib/services/local_ai_bridge.dart`):
`127.0.0.1:8080`, a hard-coded LAN address, and `10.0.2.2:8080` (Android emulator -> host machine).
Everything runs offline; the app also bundles pre-generated Santali audio in `frontend/assets/audio/`.
