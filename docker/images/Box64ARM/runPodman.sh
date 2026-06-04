#!/bin/bash
IMAGE_NAME="localhost/box64"
CONTAINER_NAME="box64"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$(podman images -q "$IMAGE_NAME" 2>/dev/null)" ]; then
  echo "Image not found, building..."
  podman build --cgroup-manager=cgroupfs -t "$IMAGE_NAME" "$SCRIPT_DIR" || { echo "Build failed, aborting."; exit 1; }
fi

if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container already up, entering..."
  podman exec -it $CONTAINER_NAME bash
elif podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container stopped, starting..."
  podman start -ai $CONTAINER_NAME
else
  echo "Creating container..."
  mkdir -p "$HOME/app"
  podman run -it \
    --cgroup-manager=cgroupfs \
    --pull=never \
    --name box64 \
    -v "$HOME/app:/root/app" \
    localhost/box64 bash
fi