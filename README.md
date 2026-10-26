# SIH 26042 — Mother-Tongue Vernacular Classroom AI & Translation Assistant

An offline-first Flutter app plus a local Python AI server that helps primary-school teachers teach in the mother tongue. It translates Hindi to Santali (Ol Chiki), speaks Santali aloud, and generates lesson material (lessons, worksheets, flashcards, teaching packages).

## Main features

- Live classroom screen with microphone input, Hindi speech recognition, Hindi → Santali translation and Santali voice output
- Lessons, worksheets, flashcards, activities and a generated "teaching package" based on a built-in curriculum
- Offline classroom sharing (QR code based) between devices
- Bundled pre-generated Santali audio so common phrases work without the AI server
- Local AI server that runs entirely on your own machine — no cloud APIs

## Technologies used

| Part | Technology |
|------|------------|
| Frontend (`frontend/`) | Flutter / Dart (Android and Windows targets are configured), packages: `http`, `audioplayers`, `record`, `speech_to_text`, `mobile_scanner`, `qr_flutter`, `shared_preferences`, … |
| Backend (`backend/`) | Python, PyTorch, Hugging Face Transformers, SNAC, NVIDIA NeMo (ASR), plain `http.server` |
| Models | [IndicTrans2](https://huggingface.co/ai4bharat/indictrans2-indic-indic-dist-320M) (translation), Quipus 0.6 Speech v2 (Santali TTS), IndicConformer (Hindi ASR) |

There is no database; the project has a frontend and a backend only.

## Project structure

```
.
├── frontend/                 Flutter app
│   ├── lib/
│   │   ├── app/              theme, routes, app shell
│   │   ├── screens/          home, live class, lessons, worksheets, flashcards, settings, ...
│   │   ├── services/         translation, speech, TTS, recorder, local AI bridge, curriculum generator
│   │   ├── models/  data/  widgets/
│   ├── assets/audio/         bundled Santali audio
│   ├── android/  windows/    platform projects
│   ├── test/                 Flutter tests
│   └── pubspec.yaml
├── backend/
│   ├── local_ai_server.py    local AI server (ASR + translation + TTS), port 8080
│   ├── download_indictrans2.py
│   ├── download_quipus.py
│   ├── models/               model configs/tokenizers (weights are downloaded, not committed)
│   ├── scripts/              CLI tools, verification and benchmark scripts
│   ├── test_audio/           sample Hindi audio
│   ├── requirements.txt
│   └── .env.example
├── docs/ARCHITECTURE.md
├── .gitignore
└── README.md
```

## Prerequisites

- Python 3.10+
- Flutter SDK (the app requires Dart `^3.12.2`) — only needed for the app
- Android Studio / an emulator or device, or Windows desktop support enabled in Flutter
- A Hugging Face account and access token (to download the Quipus TTS weights)

## Installation

### 1. Backend

```bash
cd backend
python3 -m venv venv
source venv/bin/activate          # Windows PowerShell: .\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 2. Environment variables

```bash
cp .env.example .env              # then put your real token in .env (never commit it)
export HF_TOKEN=your_token_here   # the download script reads HF_TOKEN from the environment
```

### 3. Download model weights (large files, not stored in Git)

```bash
python download_indictrans2.py
python download_quipus.py
```

The speech-recognition model (`backend/models/indicconformer/indicconformer_stt_hi_hybrid_rnnt_large.nemo`) has no download script in this project. Without it the `/asr` endpoint will not work; translation and TTS still can.

### 4. Frontend

```bash
cd frontend
flutter pub get
```

## Running

Start the backend (from the `backend/` folder):

```bash
python local_ai_server.py
```

It listens on port 8080 with `GET /status`, `POST /asr`, `POST /translate`, `POST /tts`.

Run the app (from the `frontend/` folder):

```bash
# Android device over USB: let the phone reach the server on your computer
adb reverse tcp:8080 tcp:8080
flutter run

# Windows desktop
flutter run -d windows
```

The app looks for the server at `127.0.0.1:8080`, then a hard-coded LAN address, then `10.0.2.2:8080` (Android emulator). See `frontend/lib/services/local_ai_bridge.dart`.

## Testing

Run the scripts from the `backend/` folder (they need the model weights):

```bash
python scripts/test_indictrans2.py        # Hindi -> Santali translation
python scripts/verify_multilanguage.py    # translation across multiple languages
python scripts/verify_stage15_tts.py      # Quipus TTS
python scripts/test_server_endpoints.py   # needs local_ai_server.py running
bash scripts/run_pipeline.sh "हिंदी वाक्य"  # translate + speak
```

Flutter tests (from `frontend/`):

```bash
flutter test
flutter analyze
```

## Screenshots

No screenshots were included in the project yet. Add images to `docs/screenshots/` and link them here.

## Security note

No API keys or tokens are stored in this repository. Keep your Hugging Face token in `backend/.env`, which is git-ignored.
