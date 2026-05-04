#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# Deployment script for node57 on AWS EC2
# ─────────────────────────────────────────────

APP_NAME="node57"
APP_DIR="/opt/${APP_NAME}"
SERVICE_NAME="${APP_NAME}"
DOCKER_IMAGE="${DOCKER_IMAGE:-${APP_NAME}:latest}"

echo "==> Starting deployment of ${APP_NAME}"

# Pull the latest Docker image (if using a registry)
if [ -n "${DOCKER_REGISTRY:-}" ]; then
  echo "==> Pulling image from registry: ${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
  docker pull "${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
  DOCKER_IMAGE="${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
fi

# Ensure app directory exists
mkdir -p "${APP_DIR}"

# Copy docker-compose and env file
cp docker-compose.yml "${APP_DIR}/docker-compose.yml"

if [ -f ".env" ]; then
  cp .env "${APP_DIR}/.env"
fi

cd "${APP_DIR}"

# Stop existing containers gracefully
echo "==> Stopping existing containers..."
docker compose down --remove-orphans || true

# Start updated containers
echo "==> Starting updated containers..."
docker compose up -d --pull always

# Wait for health check to pass
echo "==> Waiting for application to become healthy..."
RETRIES=30
COUNT=0
until curl -sf http://localhost:3000/health > /dev/null; do
  COUNT=$((COUNT + 1))
  if [ "${COUNT}" -ge "${RETRIES}" ]; then
    echo "ERROR: Application did not become healthy after ${RETRIES} attempts."
    docker compose logs app
    exit 1
  fi
  echo "  Waiting... attempt ${COUNT}/${RETRIES}"
  sleep 3
done

echo "==> Deployment of ${APP_NAME} completed successfully."
echo "==> Health check: $(curl -sf http://localhost:3000/health)"