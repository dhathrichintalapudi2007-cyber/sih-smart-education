#!/usr/bin/env bash
# Master pipeline: Hindi text -> Santali (IndicTrans2) -> Santali speech (Quipus TTS)
# Usage (from anywhere):  bash backend/scripts/run_pipeline.sh "your Hindi sentence"
# Requires the Python dependencies from backend/requirements.txt and the downloaded model weights.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$(dirname "$SCRIPT_DIR")"
PYTHON="${PYTHON:-python3}"

TEXT="${1:-कर्म करो, फल की चिंता मत करो।}"

echo "======================================================================"
echo "  SIH PROBLEM STATEMENT 26042 — FULL TEXT & VOICE SANTALI PIPELINE"
echo "======================================================================"
echo "Input Hindi Sentence: $TEXT"
echo ""

echo "[STEP 1/2] Translating Hindi -> Santali Ol Chiki..."
"$PYTHON" "$SCRIPT_DIR/run_live_translation.py" "$TEXT"

SANTALI_TEXT=$(cat "$BACKEND_DIR/live_translation_result.txt")
echo "  -> Santali Translation: $SANTALI_TEXT"
echo ""

echo "[STEP 2/2] Synthesizing Santali Voice Audio..."
"$PYTHON" "$SCRIPT_DIR/run_live_tts.py" "$SANTALI_TEXT"

echo "======================================================================"
echo "  SUCCESS! Audio written to: $BACKEND_DIR/test_audio/tts_outputs/"
echo "======================================================================"
