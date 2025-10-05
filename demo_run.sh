#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend"

echo "Setting up backend..."
cd "$BACKEND_DIR"
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "Starting backend at http://localhost:8000"
uvicorn main:app --host 0.0.0.0 --port 8000 &
UVICORN_PID=$!

echo "Starting frontend at http://localhost:3000"
cd "$FRONTEND_DIR"
if [ ! -d "node_modules" ]; then
  npm install
fi
npm start

kill $UVICORN_PID || true
deactivate || true
