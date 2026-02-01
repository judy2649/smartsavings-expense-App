#!/usr/bin/env bash
set -euo pipefail

# Helper to start the Firestore emulator in CI.
# Installs firebase-tools and launches the emulator in the background.

EMULATOR_HOST=${EMULATOR_HOST:-127.0.0.1}
EMULATOR_PORT=${EMULATOR_PORT:-8080}
PROJECT_ID=${PROJECT_ID:-demo-project}

echo "[ci/start_emulator] Installing firebase-tools..."
npm install -g firebase-tools@latest

if [ ! -f firebase.json ]; then
  echo "{\"emulators\":{\"firestore\":{\"port\":${EMULATOR_PORT}}}}" > firebase.json
fi

echo "[ci/start_emulator] Starting Firestore emulator on ${EMULATOR_HOST}:${EMULATOR_PORT} (project ${PROJECT_ID})"
nohup firebase emulators:start --only firestore --host ${EMULATOR_HOST} --project ${PROJECT_ID} > firebase-emulator.log 2>&1 &
EMULATOR_PID=$!

# Wait for the emulator port to be open (up to 60s)
echo "[ci/start_emulator] Waiting for emulator to be ready..."
for i in {1..60}; do
  if nc -z ${EMULATOR_HOST} ${EMULATOR_PORT}; then
    echo "[ci/start_emulator] Emulator is up"
    exit 0
  fi
  sleep 1
done

echo "[ci/start_emulator] Emulator failed to start. See firebase-emulator.log"
cat firebase-emulator.log || true
kill ${EMULATOR_PID} || true
exit 1
